require 'spec_helper'
require 'vagrant-dsc/provisioner'
require 'vagrant-dsc/config'
require 'rspec/its'

describe VagrantPlugins::DSC::Config do
  # include_context "unit"
  let(:instance) { described_class.new }

  describe "defaults" do
    subject do
      instance.tap do |o|
        o.finalize!
      end
    end

    its("manifest_file")      { expect = "default.ps1" }
    its("manifests_path")     { expect = "." }
    its("configuration_name") { expect = "default" }
    its("mof_file")           { expect be_nil }
    its("module_path")        { expect be_nil }
    its("options")            { expect = [] }
    its("facter")             { expect = {} }
    its("synced_folder_type") { expect be_nil }
    its("temp_dir")           { expect match /^\/tmp\/vagrant-dsc-*/ }
    its("working_directory")  { expect be_nil }
  end
end


# require_relative "../base"

# require "vagrant/util/platform"

# require Vagrant.source_root.join("plugins/providers/docker/config")

# describe VagrantPlugins::DockerProvider::Config do
#   include_context "unit"

#   let(:machine) { double("machine") }

#   let(:build_dir) do
#     temporary_dir.tap do |dir|
#       dir.join("Dockerfile").open("w") do |f|
#         f.write("Hello")
#       end
#     end
#   end

#   def assert_invalid
#     errors = subject.validate(machine)
#     if !errors.values.any? { |v| !v.empty? }
#       raise "No errors: #{errors.inspect}"
#     end
#   end

#   def assert_valid
#     errors = subject.validate(machine)
#     if !errors.values.all? { |v| v.empty? }
#       raise "Errors: #{errors.inspect}"
#     end
#   end

#   def valid_defaults
#     subject.image = "foo"
#   end

#   describe "defaults" do
#     before { subject.finalize! }

#     its(:build_dir) { should be_nil }
#     its(:expose) { should eq([]) }
#     its(:cmd) { should eq([]) }
#     its(:env) { should eq({}) }
#     its(:force_host_vm) { should be_false }
#     its(:host_vm_build_dir_options) { should be_nil }
#     its(:image) { should be_nil }
#     its(:name) { should be_nil }
#     its(:privileged) { should be_false }
#     its(:vagrant_machine) { should be_nil }
#     its(:vagrant_vagrantfile) { should be_nil }
#   end

#   before do
#     # By default lets be Linux for validations
#     Vagrant::Util::Platform.stub(linux: true)
#   end

#   it "should be invalid if both build dir and image are set" do
#     subject.build_dir = build_dir
#     subject.image = "foo"
#     subject.finalize!
#     assert_invalid
#   end

#   describe "#build_dir" do
#     it "should be valid if not set with image" do
#       subject.build_dir = nil
#       subject.image = "foo"
#       subject.finalize!
#       assert_valid
#     end

#     it "should be valid with a valid directory" do
#       subject.build_dir = build_dir
#       subject.finalize!
#       assert_valid
#     end

#     it "should be invalid with a directory that doesn't have a Dockerfile" do
#       subject.build_dir = temporary_dir.to_s
#       subject.finalize!
#       assert_invalid
#     end
#   end

#   describe "#expose" do
#     before do
#       valid_defaults
#     end

#     it "uniqs the ports" do
#       subject.expose = [1, 1, 4, 5]
#       subject.finalize!
#       assert_valid

#       expect(subject.expose).to eq([1, 4, 5])
#     end
#   end

#   describe "#image" do
#     it "should be valid if set" do
#       subject.image = "foo"
#       subject.finalize!
#       assert_valid
#     end

#     it "should be invalid if not set" do
#       subject.image = nil
#       subject.finalize!
#       assert_invalid
#     end
#   end

#   describe "#link" do
#     before do
#       valid_defaults
#     end

#     it "should be valid with good links" do
#       subject.link "foo:bar"
#       subject.link "db:blah"
#       subject.finalize!
#       assert_valid
#     end

#     it "should be invalid if not name:alias" do
#       subject.link "foo"
#       subject.finalize!
#       assert_invalid
#     end

#     it "should be invalid if too many colons" do
#       subject.link "foo:bar:baz"
#       subject.finalize!
#       assert_invalid
#     end
#   end

#   describe "#merge" do
#     let(:one) { described_class.new }
#     let(:two) { described_class.new }

#     subject { one.merge(two) }

#     context "#build_dir and #image" do
#       it "overrides image if build_dir is set previously" do
#         one.build_dir = "foo"
#         two.image = "bar"

#         expect(subject.build_dir).to be_nil
#         expect(subject.image).to eq("bar")
#       end

#       it "overrides image if build_dir is set previously" do
#         one.image = "foo"
#         two.build_dir = "bar"

#         expect(subject.image).to be_nil
#         expect(subject.build_dir).to eq("bar")
#       end

#       it "preserves if both set" do
#         one.image = "foo"
#         two.image = "baz"
#         two.build_dir = "bar"

#         expect(subject.image).to eq("baz")
#         expect(subject.build_dir).to eq("bar")
#       end
#     end

#     context "env vars" do
#       it "should merge the values" do
#         one.env["foo"] = "bar"
#         two.env["bar"] = "baz"

#         expect(subject.env).to eq({
#           "foo" => "bar",
#           "bar" => "baz",
#         })
#       end
#     end

#     context "exposed ports" do
#       it "merges the exposed ports" do
#         one.expose << 1234
#         two.expose = [42, 54]

#         expect(subject.expose).to eq([
#           1234, 42, 54])
#       end
#     end

#     context "links" do
#       it "should merge the links" do
#         one.link "foo"
#         two.link "bar"

#         expect(subject._links).to eq([
#           "foo", "bar"])
#       end
#     end
#   end

#   describe "#vagrant_machine" do
#     before { valid_defaults }

#     it "should convert to a symbol" do
#       subject.vagrant_machine = "foo"
#       subject.finalize!
#       assert_valid
#       expect(subject.vagrant_machine).to eq(:foo)
#     end
#   end

#   describe "#vagrant_vagrantfile" do
#     before { valid_defaults }

#     it "should be valid if set to a file" do
#       subject.vagrant_vagrantfile = temporary_file.to_s
#       subject.finalize!
#       assert_valid
#     end

#     it "should not be valid if set to a non-existent place" do
#       subject.vagrant_vagrantfile = "/i/shouldnt/exist"
#       subject.finalize!
#       assert_invalid
#     end
#   end
# end
