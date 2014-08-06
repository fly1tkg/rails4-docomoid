require 'openid'
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class ConsumerController < ApplicationController
  layout nil

  DOCOMO_OP_IDENTIFIER = "https://i.mydocomo.com"

  def index
    response.headers['X-XRDS-Location'] = url_for(:controller => 'server', :action => 'xrds', :only_path => false)
  end

  def begin
    oidreq = consumer.begin DOCOMO_OP_IDENTIFIER

    return_to = url_for :action => 'complete', :only_path => false

    realm = url_for :action => 'index', :id => nil, :only_path => false

    if oidreq.send_redirect?(realm, return_to)
      redirect_to oidreq.redirect_url(realm, return_to)
    else
      render :text => oidreq.html_markup(realm, return_to)
    end
  end

  def complete
    parameters = params.reject{|k,v|request.path_parameters[k]}.reject{|k,v| k == 'action' || k == 'controller'}
    logger.debug parameters
    openid_request = consumer.complete(parameters, complete_url)
    logger.debug openid_request
    logger.debug openid_request.status
    logger.debug openid_request.message
  end

  private

  def consumer
    if @consumer.nil?
      dir = Pathname.new(Rails.root).join('db').join('cstore')
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end

end
