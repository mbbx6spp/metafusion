# Cryptography helper module <tt>Metafusion::Crypto</tt> as well as
# <tt>Metafusion::Crypto::PrivateKey</tt> and 
# <tt>Metafusion::Crypto::DigitalSignature</tt> classes.

require 'openssl'
require 'digest/sha1'

# Module that contains Cryptography helper methods and the 
# <tt>Metafusion::Crypto::Key</tt> class to be utilized in 
# public key encryption.
module Metafusion::Crypto

  # Generate private and public keys
  # 1. <tt>private_file</tt> - file name of private key to generate (default = "rsa_key")
  # 2. <tt>public_file</tt> - file name of public key to generate (default = "#{private_key}.pub")
  # 3. <tt>bits</tt> - number of bits for key (default = 1024)
  # 4. <tt>clean</tt> - specifies if existing key files should
  #    zapped and replaced by newly generated keys (default = true)
  # 
  # Returns the private key generated.
  # 
  # Usage:
  #   priv_key = Metafusion::Crypto.generate_key_pair
  def self.generate_key_pair(private_file = "rsa_key", 
                         public_file = "#{private_file}.pub", 
                         bits = 512, clean = true)
    if clean
      File.delete(private_file) if File.exists?(private_file)
      File.delete(public_file) if File.exists?(public_file)
    end
    private_key = OpenSSL::PKey::RSA.new(bits)
    File.open(private_file, "w+") do |fp| 
      fp << private_key.to_s
    end
    File.open(public_file,  "w+") do |fp| 
      fp << private_key.public_key.to_s
    end
    private_key
  end
  
  # <tt>Metafusion::Crypto::DigitalSignature</tt> provides easier 
  # a more streamlined API to create digital signatures without 
  # needing to know what that entails.
  # 
  # Usage:
  #  include Metafusion::Crypto
  #  sig = DigitalSignature.from_file('rsa_key.pub', 'rsa_key')
  #  original_text = "my clear text message"
  #  crypted_text = sig.encrypt(original_text)
  #  plain_text = sig.decrypt(crypted_text)
  #  puts "It worked - let's celebrate!" if original_text == plain_text
  class DigitalSignature
    # Class methods
    class << self
      # Loads and constructs key from file <tt>private_filename</tt> given.
      def from_keys(public_filename = "rsa_key.pub", 
                         private_filename = nil)
        return self.new(File.read(public_filename)) unless private_filename
        self.new(File.read(public_filename), File.read(private_filename))
      end
    end

    # Constructor that takes the private and public key data.
    # Only the <tt>public_data</tt> is required since not all
    # <tt>DigitalSignature</tt> class clients will have access 
    # to the private key.
    def initialize(public_data, private_data = nil)
      @private_key = OpenSSL::PKey::RSA.new(private_data) if private_data
      @public_key = OpenSSL::PKey::RSA.new(public_data)
    end
  
    # Encrypts given <tt>text</tt> using key instance.  This assumes
    # that private key data was provided at instantiation step.
    def encrypt(text)
      Base64.encode64(@private_key.send("private_encrypt", text)) if @private_key
    end
    
    # Decrypts given <tt>text</tt> using key instance.
    def decrypt(text)
      @public_key.send("public_decrypt", Base64.decode64(text))
    end
    
    private
      attr_accessor :private_key, :public_key
  end

  # <tt>Metafusion::Crypto::PrivateKey</tt> provides class that wraps 
  # the boilerplate private key encryption API from the Ruby 
  # standard library OpenSSL implementation.
  # 
  # Usage:
  #  include Metafusion::Crypto
  #  pkey = PrivateKey.new('mypassphrase')
  #  original_text = 'Yo yo yo.  What up dog?'
  #  crypted_text = pkey.encrypt(original_text)
  #  plain_text = pkey.decrypt(crypted_text)
  #  puts "Let's roll and celebrate - it worked" if original_text == plain_text
  class PrivateKey
    # Class methods
    class << self
      # Read in private key from file
      def from_file(key_file = 'rsa_key')
        return self.new(File.read(key_file))
      end
    end
  
    # Creates <tt>PrivateKey</tt> instance given
    # <tt>raw_passphrase</tt> and <tt>cipher</tt>.
    # The default cipher is AES-256-CBC.
    def initialize(raw_passphrase, cipher = "aes-256-cbc")
      @encrypt_cipher = OpenSSL::Cipher::Cipher.new(cipher)
      @decrypt_cipher = OpenSSL::Cipher::Cipher.new(cipher)
      @key = Digest::SHA1.hexdigest(raw_passphrase)
    end
    
    # Encrypts given <tt>text</tt> using key instance
    def encrypt(text)
      @encrypt_cipher.encrypt(@key)
      s = @encrypt_cipher.update(text)
      s << @encrypt_cipher.final
      Base64.encode64(s)
    end
    
    # Decrypts given <tt>text</tt> using key instance
    def decrypt(text)
      @decrypt_cipher.decrypt(@key)
      s = @decrypt_cipher.update(Base64.decode64(text))
      s << @decrypt_cipher.final
      s
    end
  end
  
  # Encodes attributes to be sent over to Paypal securely.
  # 
  # For example,
  #   encoder = PaypalEncoder.new(File.read(app_cert_file), File.read(app_key_file), File.read(paypal_cert_file))
  #   ....
  #   data1 = encoder.encrypt(product1_hash)
  #   data2 = encoder.encrypt(product2_hash)
  class PaypalEncoder
    def initialize(app_cert_content, app_key_content, paypal_cert_content)
      @app_cert = certify(app_cert_content)
      @app_key = keyify(app_key_content)
      @paypal_cert = certify(paypal_cert_content)
    end

    # Encrypts the payment button information they way Paypal expects it.
    def encrypt(attrs)
      data = attributes.map { |k, v| "#{k}=#{v}" }.join("\n")
      signed = OpenSSL::PKCS7::sign(@app_cert, @app_key, data, [], OpenSSL::PKCS7::BINARY)
      OpenSSL::PKCS7::encrypt([@paypal_cert], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
    end

  private
    def certify(content)
      OpenSSL::X509::Certificate(content)
    end

    def keyify(content)
      OpenSSL::PKey::RSA.new(content, '')
    end
  end
end
