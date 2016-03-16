require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'

describe Hashie::Extensions::DeepFind do
  subject { Class.new(Hash) { include Hashie::Extensions::DeepFind } }
  let(:hash) do
    {
      library: {
        books: [
          { title: 'Call of the Wild', author: 'Jack London' },
          { title: 'Moby Dick', author: 'Herman Melville' }
        ],
        shelves: nil,
        location: {
          address: '123 Library St.',
          title: 'Main Library'
        },
        employees: [
          {info: {name: "John", surname: "Smith", prefix: "Mr."}, position: "Head Librarian"}
        ],
      },
      title: 'Book Listing'
    }
  end
  let(:instance) { subject.new.update(hash) }

  describe '#deep_find' do
    it 'detects a value from a nested hash' do
      expect(instance.deep_find(:address)).to eq('123 Library St.')
    end

    it 'detects a value from a nested array' do
      expect(instance.deep_find(:author)).to eq('Jack London')
    end

    it 'detects an value even if the value itself is an object' do
      expect(instance.deep_find(:info)).to eq({name: "John", surname: "Smith", prefix: "Mr."})
    end

    it 'returns nil if it does not find a match' do
      expect(instance.deep_find(:wahoo)).to be_nil
    end
  end

  describe '#deep_find_all' do
    it 'detects all values from a nested hash' do
      expect(instance.deep_find_all(:title)).to include('Call of the Wild', 'Moby Dick', 'Main Library', 'Book Listing')
    end

    it 'returns nil if it does not find any matches' do
      expect(instance.deep_find_all(:wahoo)).to be_nil
    end
  end

  context 'on an ActiveSupport::HashWithIndifferentAccess' do
    subject(:instance) { hash.with_indifferent_access.extend(Hashie::Extensions::DeepFind) }

    describe '#deep_find' do
      it 'indifferently detects a value from a nested hash' do
        expect(instance.deep_find(:address)).to eq('123 Library St.')
        expect(instance.deep_find('address')).to eq('123 Library St.')
      end

      it 'indifferently detects a value from a nested array' do
        expect(instance.deep_find(:author)).to eq('Jack London')
        expect(instance.deep_find('author')).to eq('Jack London')
      end

      it 'indifferently detects an value even if the value itself is an object' do
        expect(instance.deep_find(:info)).to eq({"name" => "John", "surname" => "Smith", "prefix" => "Mr."})
        expect(instance.deep_find('info')).to eq({"name" => "John", "surname" => "Smith", "prefix" => "Mr."})
      end

      it 'indifferently returns nil if it does not find a match' do
        expect(instance.deep_find(:wahoo)).to be_nil
        expect(instance.deep_find('wahoo')).to be_nil
      end
    end

    describe '#deep_find_all' do
      it 'indifferently detects all values from a nested hash' do
        expect(instance.deep_find_all(:title)).to include('Call of the Wild', 'Moby Dick', 'Main Library', 'Book Listing')
        expect(instance.deep_find_all('title')).to include('Call of the Wild', 'Moby Dick', 'Main Library', 'Book Listing')
      end

      it 'indifferently returns nil if it does not find any matches' do
        expect(instance.deep_find_all(:wahoo)).to be_nil
        expect(instance.deep_find_all('wahoo')).to be_nil
      end
    end
  end

  context 'on a Hash including Hashie::Extensions::IndifferentAccess' do
    let(:klass) { Class.new(Hash) { include Hashie::Extensions::IndifferentAccess } }
    subject(:instance) { klass[hash.dup].extend(Hashie::Extensions::DeepFind) }

    describe '#deep_find' do
      it 'indifferently detects a value from a nested hash' do
        expect(instance.deep_find(:address)).to eq('123 Library St.')
        expect(instance.deep_find('address')).to eq('123 Library St.')
      end

      it 'indifferently detects a value from a nested array' do
        expect(instance.deep_find(:author)).to eq('Jack London')
        expect(instance.deep_find('author')).to eq('Jack London')
      end

      it 'indifferently detects an value even if the value itself is an object' do
        expect(instance.deep_find(:info)).to eq({"name" => "John", "surname" => "Smith", "prefix" => "Mr."})
        expect(instance.deep_find('info')).to eq({"name" => "John", "surname" => "Smith", "prefix" => "Mr."})
      end

      it 'indifferently returns nil if it does not find a match' do
        expect(instance.deep_find(:wahoo)).to be_nil
        expect(instance.deep_find('wahoo')).to be_nil
      end
    end

    describe '#deep_find_all' do
      it 'indifferently detects all values from a nested hash' do
        expect(instance.deep_find_all(:title)).to include('Call of the Wild', 'Moby Dick', 'Main Library', 'Book Listing')
        expect(instance.deep_find_all('title')).to include('Call of the Wild', 'Moby Dick', 'Main Library', 'Book Listing')
      end

      it 'indifferently returns nil if it does not find any matches' do
        expect(instance.deep_find_all(:wahoo)).to be_nil
        expect(instance.deep_find_all('wahoo')).to be_nil
      end

      it "indifferently returns the proper construct of a nested value" do
        expect(instance.deep_find_all(:employees)).to include([
          {"info": {"name": "John", "surname": "Smith", "prefix": "Mr."}, "position": "Head Librarian"}
        ])

        expect(instance.deep_find_all("employees")).to include([
          {"info": {"name": "John", "surname": "Smith", "prefix": "Mr."}, "position": "Head Librarian"}
        ])
      end
    end
  end
end
