module MCollective
  module RPC
    class Anthracite<Audit
      require 'pp'
      require 'net/http'

      def audit_request(request, connection)
        anthracite_host = Config.instance.pluginconf["rpcaudit.anthracite_host"] || "localhost"
        anthracite_port = Config.instance.pluginconf["rpcaudit.anthracite_port"] || "8081"
        uri = URI.parse("http://#{anthracite_host}:#{anthracite_port}/events/add/script")

        now = Time.now.to_i
        event_desc = "reqid=#{request.uniqid}: reqtime=#{request.time} caller=#{request.caller}@#{request.sender} agent=#{request.agent} action=#{request.action} data=#{request.data.pretty_print_inspect}"
        begin
          response = Net::HTTP.post_form(uri, { "event_timestamp" => "#{now}", "event_tags" => "mcollective", "event_desc" => "#{event_desc}" })
        rescue Exception => e
          Log.error("Couldn't send audit msg to anthracite, #{e}")
        end
      end
    end
  end
end
