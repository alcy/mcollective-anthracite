module MCollective
  module RPC
    class Anthracite<Audit
      require 'pp'
      require 'net/http'

      def audit_request(request, connection)
        anthracite_host = Config.instance.pluginconf["rpcaudit.anthracite_host"] || "localhost"
        anthracite_port = Config.instance.pluginconf["rpcaudit.anthracite_port"] || "8081"
        anthracite_open_timeout = Config.instance.pluginconf["rpcaudit.anthracite_open_timeout"] || 5
        anthracite_read_timeout = Config.instance.pluginconf["rpcaudit.anthracite_read_timeout"] || 5

        uri = URI.parse("http://#{anthracite_host}:#{anthracite_port}/events/add/script")
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = anthracite_open_timeout
        http.read_timeout = anthracite_read_timeout

        now = Time.now.to_i
        event_desc = "reqid=#{request.uniqid}: reqtime=#{request.time} caller=#{request.caller}@#{request.sender} agent=#{request.agent} action=#{request.action} data=#{request.data.pretty_print_inspect}"
        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data({ "event_timestamp" => "#{now}", "event_tags" => "mcollective", "event_desc" => "#{event_desc}" })

        begin
          response = http.request(req)
        rescue Exception => e
          Log.error("Couldn't send audit msg to anthracite, #{e}")
        end
      end
    end
  end
end
