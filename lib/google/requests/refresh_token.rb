module Google
  module Requests
    class RefreshToken
      def body
        URI.encode_www_form(payload)
      end

      private

      def payload
        {
          client_id: client_id,
          client_secret: client_secret,
          grant_type: :refresh_token,
          refresh_token: refresh_token,
        }
      end

      def client_id
        ENV.fetch('CLIENT_ID')
      end

      def client_secret
        ENV.fetch('CLIENT_SECRET')
      end

      def refresh_token
        ENV.fetch('REFRESH_TOKEN')
      end
    end
  end
end