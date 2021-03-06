require 'addressable'
require 'webmock'

class PayjpMock::Request
  include WebMock::API
  using   PayjpMock::Ext::Hash

  API_HOST    = 'api.pay.jp'.freeze
  API_VERSION = 'v1'.freeze
  API_BASE    = "https://#{API_HOST}/#{API_VERSION}".freeze

  def initialize(method, path_pattern, params, response)
    @method   = method
    @url      = Addressable::Template.new(API_BASE + path_pattern)
    @params   = params.deep_transform_values(&:to_s)
    @response = response
  end

  def stub
    stub_request(@method, @url)
      .with(body: @params)
      .to_return(body: @response.body, status: @response.status, exception: @response.exception)

    JSON.parse(@response.body || '{}').symbolize_keys
  end
end
