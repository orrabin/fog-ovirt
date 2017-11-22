module Fog
  module Compute
    class Ovirt
      class Real
        def create_affinity_group(attrs)
         # client.create_affinity_group(attrs)
        end
      end

      class Mock
        def create_affinity_group(attrs)
          xml = read_xml('affinitygroup.xml')
          OvirtSDK4::Reader.read(Nokogiri::XML(xml).root.to_s)
        end
      end
    end
  end
end
