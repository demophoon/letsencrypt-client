require 'spec_helper'
describe 'client' do

  context 'with defaults for all parameters' do
    it { should contain_class('letsencrypt_client') }
  end
end
