Shindo.tests("Fog::Compute[:ovirt] | vm_create request", 'ovirt') do

  compute = Fog::Compute[:ovirt]
  name_base = Time.now.to_i

  tests("Create VM") do
    response = compute.create_vm(:name => 'fog-'+name_base.to_s, :cluster_name => 'Default')
    test("should be a kind of OvirtSDK4::Vm") { response.kind_of?  OvirtSDK4::Vm}
  end

  tests("Create VM from template (clone)") do
    response = compute.create_vm(:name => 'fog-'+(name_base+ 1).to_s, :template_name => 'hwp_small', :cluster_name => 'Default')
    test("should be a kind of OvirtSDK4::Vm") { response.kind_of?  OvirtSDK4::Vm}
  end

  tests("Fail Creating VM") do
    begin
      response = compute.create_vm(:name => 'fog-'+name_base.to_s, :cluster_name => 'Default')
      test("should be a kind of OvirtSDK4::Vm") { response.kind_of?  OvirtSDK4::Vm} #mock never raise exceptions
    rescue => e
      #should raise vm name already exist exception.
      test("error should be a kind of OvirtSDK4::Error") { e.kind_of?  OvirtSDK4::Error}
    end
  end

end
