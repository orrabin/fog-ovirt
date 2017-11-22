module Fog
  module Compute
    class Ovirt
      class Real
        def storage_domains filter={}

          connection.system_service.storage_domains_service.list.collect do |sd|
            #filter by role is not supported by the search language. The work around is to list all, then filter.
            (filter[:role].nil? || sd.type == filter[:role]) ? sd : nil
          end.compact
        end
      end

      class Mock
        def storage_domains(filters = {})
          xml = read_xml 'storage_domains.xml'
          Nokogiri::XML(xml).xpath('/storage_domains/storage_domain').map do |sd|
            OvirtSDK4::Reader.read(sd.to_s)
          end
        end
      end
    end
  end
end
