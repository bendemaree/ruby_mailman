##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Interfaces

  ##
  # Message Classes
  #
  class Auth < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class Auth
    optional :string, :email, 2
    optional :string, :public_key, 3
    optional :string, :private_key, 4
  end

end

