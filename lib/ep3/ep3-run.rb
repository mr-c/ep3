#!/usr/bin/env ruby
# coding: utf-8
require 'optparse'
require_relative 'runtime/inspector'

def run_fluentd(target_dir, template_dir, quiet, debug)
  system_conf = debug ? 'stdout-logger.conf' : 'null-logger.conf'

  FileUtils.cp(File.join(template_dir, system_conf),
               File.join(target_dir, 'workdir', 'fluentd', 'system-logger.conf'))

  info_conf = quiet ? 'null-logger.conf' : 'stdout-logger.conf'

  FileUtils.cp(File.join(template_dir, info_conf),
               File.join(target_dir, 'workdir', 'fluentd', 'info-logger.conf'))

  logger_path = File.join(ENV['EP3_LIBPATH'], 'run')
  spawn({ 'PATH' => "#{logger_path}:#{ENV['PATH']}"},
        'fluentd -qqc workdir/fluentd/fluentd.conf',
        :chdir => target_dir, :out => :err)
end

def detailed_input(input, dir)
  obj = if input.end_with? '.json'
          open(input) { |inp|
            JSON.load(inp)
          }
        else
          YAML.load_file(input)
        end
  dirname = File.dirname input
  cwlfile = File.join(dir, 'workdir', 'job.cwl')
  nss = YAML.load_file(cwlfile).fetch('$namespaces', {})
  Hash[walk(cwlfile, '.inputs', []).select{ |inp|
         obj.fetch(inp.id, nil) or not inp.default.instance_of?(InvalidValue)
       }.map{ |inp|
         val = obj.fetch(inp.id, nil)
         unless inp.default.instance_of?(InvalidValue)
           val = (val or inp.default)
         end
         [inp.id, InputParameter.parse_object(inp.type, val,
                                              dirname, {}, nss).to_h]
       }]
end

def ep3_run(args)
  parser = OptionParser.new
  parser.banner = "Usage: ep3 run [options] [<inputs.yml or inputs.json>]"
  parser.on('--target-dir=DIR')
  parser.on('--debug')
  parser.on('--quiet')

  opts = parser.getopts(args)
  unless args.length <= 1
    puts parser.help
    exit
  end

  unless ENV.include? 'EP3_TEMPLATE_DIR'
    raise 'EP3_TEMPLATE_DIR is necessary'
  end
  template_dir = ENV['EP3_TEMPLATE_DIR']

  unless ENV.include? 'EP3_LIBPATH'
    raise 'EP3_LIBPATH is necessary'
  end

  input = if args.empty?
            File.join(template_dir, 'empty.json')
          else
            f = args.pop
            raise "No such file: #{f}" unless File.exist? f
            f
          end

  dir = if opts.include? 'target-dir'
          opts['target-dir']
        else
          raise '--target-dir is needed'
        end
  unless Dir.exist? dir
    raise "Directory not found: #{dir}"
  end

  pid = run_fluentd(dir, template_dir,
                    opts.include?('quiet'), opts.include?('debug'))
  ep3_pid = nil
  begin
    open(File.join(dir, 'workdir', 'input.json'), 'w') { |f|
      f.puts JSON.dump detailed_input(input, dir)
    }
    open(File.join(dir, 'workdir', 'init.yml'), 'w') { |f|
      f.puts <<EOS
entrypoint: input.json
EOS
    }
    logfile = 'medal-log.json'
    ep3_pid = spawn({ 'PATH' => "#{ENV['EP3_LIBPATH']}/runtime:#{ENV['PATH']}", 'EP3_TEMPLATE_DIR' => template_dir },
                    "medal workdir/job.yml -i workdir/init.yml --workdir=workdir --tmpdir=tmpdir --leave-tmpdir --debug --log=#{logfile}",
                    :chdir => dir)
    _, status = Process.waitpid2 ep3_pid
    ep3_pid = nil
    if status.exited?
      0
    else
      1
    end
  rescue Interrupt
    # nop
    1
  ensure
    unless pid.nil?
      Process.kill :TERM, pid
    end
    unless ep3_pid.nil?
      Process.kill :INT, ep3_pid
    end
    Process.waitall
  end
end

if $0 == __FILE__
  ep3_run(ARGV)
end
