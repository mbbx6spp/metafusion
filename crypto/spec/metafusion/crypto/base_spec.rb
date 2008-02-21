require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

PRIVATE_KEY = 'rsa_key'
PUBLIC_KEY = 'rsa_key.pub'

def remove_rsa_keys(priv = PRIVATE_KEY, pub = PUBLIC_KEY)
    File.delete(priv) if File.exists?(priv)
    File.delete(pub) if File.exists?(pub)
end

describe Metafusion::Crypto, ".generate_key_pair" do
  before(:each) do
    remove_rsa_keys
  end
  
  it "should create a private and public RSA key pair" do
    Metafusion::Crypto.generate_key_pair
    File.exists?(PRIVATE_KEY).should be_true
    File.exists?(PUBLIC_KEY).should be_true
  end
  
  after(:each) do
    remove_rsa_keys
  end
end

describe Metafusion::Crypto::DigitalSignature do
  before(:each) do
    # ensure the keys are generated
    Metafusion::Crypto.generate_key_pair
    @private_key = "private key"
    @public_key = "public key"
    File.stub!(:read).and_return(@public_key, @private_key)
  end
  
  it "should create instance from from_keys class method" do
    Metafusion::Crypto::DigitalSignature.should_receive(:new).with(@public_key,@private_key)
    Metafusion::Crypto::DigitalSignature.from_keys(PUBLIC_KEY, PRIVATE_KEY)
  end
  
  it "should create instance from from_keys class method using private key data when only public key provided" do
    Metafusion::Crypto::DigitalSignature.should_receive(:new).with(@public_key)
    Metafusion::Crypto::DigitalSignature.from_keys(PUBLIC_KEY)
  end
  
  after(:each) do
    remove_rsa_keys
  end
end

describe Metafusion::Crypto::DigitalSignature do
  before(:each) do
    @original_text = "Charlotte Bronte rules"
    Metafusion::Crypto.generate_key_pair
    @digital_signature = Metafusion::Crypto::DigitalSignature.from_keys('rsa_key.pub', 'rsa_key')
  end
  
  it "should encrypt/decrypt round-trip back to original text" do
    crypted_text = @digital_signature.encrypt(@original_text)
    decrypted_text = @digital_signature.decrypt(crypted_text)
    decrypted_text.should eql(@original_text)
  end
  
  it "should encrypt original text to a 90 character base64 string" do
    crypted_text = @digital_signature.encrypt(@original_text)
    crypted_text.size.should be(90)
  end
  
  after(:each) do
    remove_rsa_keys
  end
end

describe Metafusion::Crypto::PrivateKey do
  before(:each) do
    @original_text = "Was Jane Eyre the ultimate feminist?"
    @private_key = Metafusion::Crypto::PrivateKey.new("currerbell1847")
  end
  
  it "should encrypt/decrypt round-trip back to original text" do
    crypted_text = @private_key.encrypt(@original_text)
    decrypted_text = @private_key.decrypt(crypted_text)
    decrypted_text.should eql(@original_text)
  end
  
  after(:each) do
    remove_rsa_keys
  end
end

describe Metafusion::Crypto::PrivateKey, ".from_file" do
  before(:each) do
    @file_name = "key_file"
    @key_content = "the key goes here"
    File.stub!(:read).and_return(@key_content)
    @pkey = mock(Metafusion::Crypto::PrivateKey)
  end
  
  it "should create new instance of PrivateKey with contents of key file supplied" do
    Metafusion::Crypto::PrivateKey.should_receive(:new).with(@key_content).and_return(@pkey)
    Metafusion::Crypto::PrivateKey.from_file(@file_name)
  end
  
  it "should read contents of file given" do
    File.should_receive(:read).with(@file_name).and_return("")
    Metafusion::Crypto::PrivateKey.from_file(@file_name)
  end
  
  after(:each) do
    @pkey = nil
    @file_name = nil
  end
end
