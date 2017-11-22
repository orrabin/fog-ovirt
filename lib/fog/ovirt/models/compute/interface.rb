module Fog
  module Compute
    class Ovirt
      class Interface < Fog::Model
        attr_accessor :raw
        identity :id

        attribute :name
        attribute :vnic_profile
        attribute :interface
        attribute :mac
        attribute :network

        def to_s
          name
        end
      end
    end
  end
end
