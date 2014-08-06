class ServerController < ApplicationController
  layout nil

  def xrds
    yadis = <<EOS
<?xml version="1.0" encoding="UTF-8"?>
<xrds:XRDS
    xmlns:xrds="xri://$xrds"
    xmlns:openid="http://openid.net/xmlns/1.0"
    xmlns="xri://$xrd*($v*2.0)">
  <XRD>
    <Service priority="0">
      <Type>http://specs.openid.net/auth/2.0/return_to</Type>
      <URI>#{request.protocol}#{request.host_with_port}</URI>
    </Service>
  </XRD>
</xrds:XRDS>
EOS
    response.headers['Content-Type'] = 'application/xrds+xml;charset=UTF-8'
    render :text => yadis
  end
end
