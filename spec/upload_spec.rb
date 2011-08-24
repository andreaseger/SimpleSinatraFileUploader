require 'spec_helper'
require 'lib/upload'

describe Upload do
  context 'makeFilename' do
    let(:u){ Upload.new }
    it 'should use the original filename if there is no file with that name' do
      u.org_filename = "test_name.png"
      u.makeFilename.should eq("test_name.png")
    end
    it 'should check if a file with that name already exists' do
      u.org_filename = "an_existing_file.png"
      Upload.expects(:exists?).with(u.org_filename).returns(true)
      u.makeFilename
    end
    it 'should append an timestamp to the filename if a equal filename exists' do
      u.org_filename = "an_existing_file.png"
      Upload.expects(:exists?).returns(true)
      u.makeFilename.should eq("an_existing_file_#{Time.now.to_i}.png")
    end
  end
  context 'self.exists?' do
    it 'should determine that a file already exists' do
      File.stubs(:exists?).returns(true)
      Upload.exists?("existing_file.png").should be_true
    end
    it 'should return false if no file with that name exists' do
      Upload.exists?("new_file.png").should be_false
    end
  end
end
