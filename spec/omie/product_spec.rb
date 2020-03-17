# frozen_string_literal: true

describe Omie::Product do
  let(:product_data) { build(:omie_product_data) }

  let(:product_data_2) do
    build(:omie_product_data, descricao: 'Another Product')
  end

  let(:attributes) do
    %i[
      codigo_produto_integracao codigo_produto descricao unidade ncm
      valor_unitario
    ]
  end

  before do
    allow(Omie::Connection).to receive(:request).and_return(product_data)
  end

  describe '.create' do
    it 'accepts empty data' do
      product = described_class.create
      expect(product).to be_a(Omie::Product)
    end

    it 'generates product with data' do
      product = described_class.create(product_data)
      attributes.each do |attr|
        expect(product.send(attr)).to_not be_blank
      end
    end
  end

  describe '.find' do
    it 'may return nil' do
      allow(Omie::Connection).to receive(:request).and_raise(Omie::RequestError)
      product = described_class.find(
        codigo_produto: product_data[:codigo_produto]
      )
      expect(product).to be_blank
    end

    it 'returns the found product' do
      product = described_class.find(
        codigo_produto: product_data[:codigo_produto]
      )
      attributes.each do |attr|
        expect(product.send(attr)).to_not be_blank
      end
    end
  end

  describe '.list' do
    it 'may return and empty list' do
      allow(Omie::Connection).to receive(:request).and_raise(Omie::RequestError)
      products = described_class.list
      expect(products).to be_empty
    end

    it 'returns a list of products' do
      allow(Omie::Connection).to receive(:request).and_return(
        'produto_servico_cadastro' => [product_data, product_data_2]
      )
      products = described_class.list

      expect(products.count).to eq(2)
      products.each do |product|
        expect(product).to be_a(Omie::Product)
        attributes.each do |attr|
          expect(product.send(attr)).to_not be_blank
        end
      end
    end
  end

  describe '.update' do
    it 'accepts empty data' do
      product = described_class.update
      expect(product).to be_a(Omie::Product)
    end

    it 'generates product with data' do
      product = described_class.update(product_data)
      attributes.each do |attr|
        expect(product.send(attr)).to_not be_blank
      end
    end
  end

  describe '.associate' do
    it 'performs correctly' do
      allow(Omie::Connection).to receive(:request).and_return(true)
      expect(described_class.associate('123', 'ABC')).to be_truthy
    end
  end

  describe 'instance methods' do
    let(:product) { Omie::Product.new }

    it 'is saved if it has the codigo_produto' do
      expect(product).to_not be_saved
      product.codigo_produto = 123
      expect(product).to be_saved
    end

    it 'tries to create if not saved' do
      expect(Omie::Product).to receive(:create).with(product.as_json)
      product.save
    end

    it 'tries to update if is saved' do
      product.codigo_produto = 123
      expect(Omie::Product).to receive(:update).with(product.as_json)
      product.save
    end

    it 'properly associate its ids' do
      expect(Omie::Product).to receive(:associate)
        .with('123', 'ABC').and_return(true)

      product.codigo_produto_integracao = 'ABC'
      product.codigo_produto = '123'

      expect(product.associate_entry).to be_truthy
    end
  end
end
