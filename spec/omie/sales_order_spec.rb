# frozen_string_literal: true

require 'spec_helper'
require 'omie'

describe Omie::SalesOrder do
	let(:sales) { Omie::SalesOrder.new }
	let(:attributes) do
    %i[
      codigo_pedido codigo_pedido_integracao codigo_status descricao_status
			numero_pedido etapa cancelada faturada ambiente valor_total_pedido
			ListaNfe
    ]
	end
	let(:sales_order_data) { build(:sales_order_data) }
	
	describe '.add_headers' do
		it 'adds atributes to class' do
			sales.add_headers(codigo_pedido_integracao: '123abc')
		 	expect(sales.as_json).to eq({"cabecalho"=>{"codigo_pedido_integracao"=>"123abc"}})
		end
	end

	describe '.add_sales_items' do
		it 'adds atributes to class' do
			sales = Omie::SalesOrder.new
			sales.add_sales_items(ide: '123abc')
		 	expect(sales.as_json).to eq({"det"=>[{"ide"=>"123abc"}]})
		end
	end

	describe '.add_shipping' do
		it 'adds atributes to class' do
			sales.add_shipping(codigo_transportadora: '123abc')
		 	expect(sales.as_json).to eq({"frete"=>{"codigo_transportadora"=>"123abc"}})
		end
	end

	describe '.add_additional_information' do
		it 'adds atributes to class' do
			sales.add_additional_information(codigo_categoria: '123abc')
		 	expect(sales.as_json).to eq({"informacoes_adicionais"=>{"codigo_categoria"=>"123abc"}})
		end
	end

	describe '.add_installment' do
		it 'adds atributes to class' do
			parcelas = {
				"data_vencimento": "04/03/2020",
				"numero_parcela": 1,
				"percentual": 50
			}

			sales.add_installment(parcela: [parcelas.as_json])
		 	expect(sales.as_json).to eq({"lista_parcelas"=>{"parcela"=> [parcelas.as_json]}})
		end
	end

	describe '.add_total_order' do
		it 'adds atributes to class' do
			sales.add_total_order(valor_total_pedido: 200)
		 	expect(sales.as_json).to eq({"total_pedido"=>{"valor_total_pedido"=>200}})
		end
	end

  describe '.create' do
		before { allow(Omie::Connection).to receive(:request).and_return(sales_order_data) }

    it 'accepts empty data' do
      salesOrder = described_class.create
      expect(salesOrder).to be_a(Omie::SalesOrder)
    end
  end

  describe '.find' do
    it 'may return nil' do
      allow(Omie::Connection).to receive(:request).and_raise(Omie::RequestError)
      salesOrder = described_class.find(codigo_pedido: 259535530)
      expect(salesOrder).to be_blank
    end
  end

  describe '.list' do
    it 'may return and empty list' do
      allow(Omie::Connection).to receive(:request).and_raise(Omie::RequestError)
      salesOrder = described_class.list
      expect(salesOrder).to be_empty
    end
  end

  describe '#change_status' do
		it 'accepts empty data' do
      allow(Omie::Connection).to receive(:request).and_return(sales_order_data)
      salesOrder = described_class.change_status('123abc', 20)
      expect(salesOrder).to be_a(Omie::SalesOrder)
    end
	end
	
	describe '#status' do
		before { allow(Omie::Connection).to receive(:request).and_return(sales_order_data) }

    it 'accepts empty data' do
      salesOrder = described_class.status('123abc')
      expect(salesOrder).to be_a(Omie::SalesOrder)
    end
	end
	
	describe '.update' do
		before { allow(Omie::Connection).to receive(:request).and_return(sales_order_data) }

    it 'accepts empty data' do
      salesOrder = described_class.update
      expect(salesOrder).to be_a(Omie::SalesOrder)
    end
  end

  describe 'instance methods' do
    it 'is saved if it has the codigo_pedido' do
      expect(sales).to_not be_saved
      sales.codigo_pedido = 123
      expect(sales).to be_saved
    end
  end
end
