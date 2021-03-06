#!/usr/bin/env ruby
require_relative 'workflownet'

def tr2medal(tr)
    inp = tr.in.map{ |i| 
        %Q|{ place: "#{i.variable}", pattern: "#{i.value}" }|
    }
    out = tr.out.map{ |o|
        %Q|{ place: "#{o.variable}", pattern: "#{o.value}" }|
    }
    cmd = if tr.command.nil? or tr.command.empty?
              '"true"'
          elsif tr.command.match?(/: /)
              <<EOCMD.chomp
 |
      #{tr.command}
EOCMD
          else
              tr.command
          end
    <<EOT
  - name: #{tr.name}
    type: shell
    in: #{if inp.empty? then [] else ["", *inp].join("\n      - ") end}
    out: #{if out.empty? then [] else ["", *out].join("\n      - ") end}
    command: #{cmd}
EOT
end

def inv2medal(tr)
    inp = tr.in.map{ |i|
        %Q|{ place: "#{i.variable}", pattern: "#{i.value}", port-to: #{i.port} }|
    }
    out = tr.out.map{ |o|
        %Q|{ place: "#{o.from}", port-to: "#{o.to}" }|
    }
    <<EOT
  - name: #{tr.name}
    type: invocation
    use: #{tr.use}
    configuration:
      tag: #{tr.tag}
      tmpdir: #{tr.tmpdir}
      workdir: #{tr.workdir}
    in: #{if inp.empty? then [] else ["", *inp].join("\n      - ") end}
    out: #{if out.empty? then [] else ["", *out].join("\n      - ") end}
EOT
end

def wfnet2medal(net)
    transitions = net.transitions
    tr_entries = transitions.map{ |tr|
        if tr.instance_of? Transition
            tr2medal(tr)
        else
            inv2medal(tr)
        end
    }
    <<EOS
configurations:
  tag: #{net.tag}
name: #{net.name}
type: network
in:
  - place: entrypoint
    pattern: _
out:
  - place: cwl.output.json
    pattern: _
  - place: ExecutionState
    pattern: _
transitions:
#{tr_entries.join("\n")}
EOS
end
