module Fog
  module Compute
    class Ovirt
      class Real
        def update_vm(attrs)
         # client.update_vm(attrs)
        end
      end

      class Mock
        def update_vm(attrs)
          xml = read_xml('vm.xml')
          OvirtSDK4::Reader.read(Nokogiri::XML(xml).root.to_s)
        end
      end
    end
  end
end
