require 'rails_helper'

RSpec.describe Link, type: :model do
  context 'validations' do
    it { should validate_presence_of(:original_url) }
    it { should validate_presence_of(:short_url) }
    it { should validate_uniqueness_of(:original_url) }
    it { should validate_uniqueness_of(:short_url) }
  end

  describe '::shrink' do
    let(:invalid_url_error) { 'is not a valid URL' }
    let(:valid_host) { 'google.com' }

    context 'input validity' do
      it 'treats blank strings as invalid' do
        link = Link.shrink('')
        expect(link.errors.messages[:original_url]).to include(invalid_url_error)
      end

      it 'treats single words as invalid' do
        link = Link.shrink('testing')
        expect(link.errors.messages[:original_url]).to include(invalid_url_error)
      end

      it 'treats localhost as invalid' do
        link = Link.shrink('localhost:3000')
        expect(link.errors.messages[:original_url]).to include(invalid_url_error)
      end

      it 'treats hosts without scheme as valid' do
        link = Link.shrink(valid_host)
        expect(link.errors.messages[:original_url]).to be_empty
      end
    end

    it 'appends a scheme to a valid host' do
      link = Link.shrink(valid_host)
      expect(link.original_url).to eq("http://#{valid_host}")
    end

    it 'returns the same shortened URL for the same site' do
      link1 = Link.shrink(valid_host)
      link2 = Link.shrink(valid_host)
      expect(link1.short_url).to eq(link2.short_url)
    end

    it 'does not create a different entry for the same site' do
      link1 = Link.shrink(valid_host)
      link2 = Link.shrink(valid_host)
      expect(link1.id).to eq(link2.id)
    end
  end

  describe '::generate_short_url' do
    it 'generates the same string for the same input if run at the same time' do
      expect(Link.generate_short_url).to eq(Link.generate_short_url)
    end

    it 'generates a different string for the same input if not run at the same time' do
      link1 = Link.generate_short_url
      sleep(1)
      link2 = Link.generate_short_url
      expect(link1).not_to eq(link2)
    end
  end
end