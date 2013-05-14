require 'rubygems'
require File.dirname(__FILE__) + '/../config/environment'

require 'logger'
$logger = Logger.new STDOUT
$logger.level=Logger::Severity::DEBUG
