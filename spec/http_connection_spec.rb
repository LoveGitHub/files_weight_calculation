describe 'HttpConnection', 'client didn\'t provide valid credentials' do

  describe "When email id is invlid" do
    it "wouldn't allow the client to log in" do
      @client = Client.new('c664cbdc-6b11', 'aruprakshit@mail.com', 'arupws1987')
      proc { @client.send(:login_to_host, true) }.must_raise RuntimeError
    end
  end

  describe "When password is invlid" do
    it "wouldn't allow the client to log in" do
      @client = Client.new('c664cbdc-6b11', 'aruprakshit@rocketmail.com', 'xjbkkbd')
      proc { @client.send(:login_to_host, true) }.must_raise RuntimeError
    end
  end

  describe "When api id is invlid" do
    it "wouldn't allow the client to log in" do
      @client = Client.new('c664cbdc-11', 'aruprakshit@rocketmail.com', 'arupws1987')
      proc { @client.send(:login_to_host, true) }.must_raise RuntimeError
    end
  end

end
