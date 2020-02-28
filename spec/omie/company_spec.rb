# frozen_string_literal: true

require 'spec_helper'
require 'omie'

describe Omie::Company do
  let(:company_data) { build(:omie_company_data) }

  let(:company_data_2) do
    build(:omie_company_data, nome_fantansia: 'Another Company')
  end

  let(:attributes) do
    %i[
      codigo_cliente_integracao cnpj_cpf contato nome_fantasia
      razao_social email
    ]
  end

  before do
    allow(Omie::Connection).to receive(:request).and_return(company_data)
  end

  describe '.create' do
    it 'accepts empty data' do
      company = described_class.create
      expect(company).to be_a(Omie::Company)
    end

    it 'generates company with data' do
      company = described_class.create(company_data)
      attributes.each do |attr|
        expect(company.send(attr)).to_not be_blank
      end
    end
  end

  describe '.find' do
    it 'may return nil' do
      allow(Omie::Connection).to receive(:request).and_raise(Omie::RequestError)
      company = described_class.find(codigo_cliente_omie: 8898)
      expect(company).to be_blank
    end

    it 'returns the found company' do
      company = described_class.find(codigo_cliente_omie: 8898)
      attributes.each do |attr|
        expect(company.send(attr)).to_not be_blank
      end
    end
  end

  describe '.list' do
    it 'may return and empty list' do
      allow(Omie::Connection).to receive(:request).and_raise(Omie::RequestError)
      companies = described_class.list
      expect(companies).to be_empty
    end

    it 'returns a list of companies' do
      allow(Omie::Connection).to receive(:request)
        .and_return('clientes_cadastro' => [company_data, company_data_2])
      companies = described_class.list

      expect(companies.count).to eq(2)
      companies.each do |company|
        expect(company).to be_a(Omie::Company)
        attributes.each do |attr|
          expect(company.send(attr)).to_not be_blank
        end
      end
    end
  end

  describe '.update' do
    it 'accepts empty data' do
      company = described_class.update
      expect(company).to be_a(Omie::Company)
    end

    it 'generates company with data' do
      company = described_class.update(company_data)
      attributes.each do |attr|
        expect(company.send(attr)).to_not be_blank
      end
    end
  end

  describe 'instance methods' do
    let(:company) { Omie::Company.new }

    it 'is saved if it has the codigo_cliente_omie' do
      expect(company).to_not be_saved
      company.codigo_cliente_omie = 123
      expect(company).to be_saved
    end

    it 'tries to create if not saved' do
      expect(Omie::Company).to receive(:create).with(company.as_json)
      company.save
    end

    it 'tries to update if is saved' do
      company.codigo_cliente_omie = 123
      expect(Omie::Company).to receive(:update).with(company.as_json)
      company.save
    end

    it 'does not include tag_values in payload' do
      company.codigo_cliente_omie = 123
      company.add_tag('Cliente')

      expect(Omie::Company).to receive(:update).with(company.as_json.except('tag_values'))
      company.save
    end

    it 'add tags to instance' do
      expected_aray = [{ tag: 'cliente' }]
      company.add_tag('cliente')
      expect(company.tag_values).to eq(['cliente'])
      expect(company.tags).to eq(expected_aray)
    end

    it 'does not add a tag value when it already exists' do
      company.tags = [{ tag: 'Cliente' }]
      company.add_tag('Cliente')
      expect(company.tag_values).to eq(['Cliente'])
    end

    it 'does not add nil tag value' do
      company.add_tag(nil)
      expect(company.tag_values).to be_blank
      expect(company.tags).to be_blank
    end

    it 'returns an empty Array of tags' do
      expect(company.tags).to eq([])
    end

    it 'sets tag_values when overriding tags' do
      company.tags = [{ tag: 'Cliente' }, { tag: 'Fornecedor' }]
      expect(company.tag_values).to eq(%w[Cliente Fornecedor])
    end
  end
end
