# frozen_string_literal: true

module Omie
  # This class abstracts the SalesOrder resource from Omie (Ref: Pedido de venda) which
  # is used for all kinds of companies in Omie, mainly Clients and Suppliers.
  # It aims at providing abstractions to the endpoints described in
  # {https://app.omie.com.br/api/v1/produtos/pedido/}.
  #
  # The class methods of Omie::SalesOrder usually perform requests to Omie API and
  # manipulate SalesOrder objects that contain the returned values.
  # Attributes' names are equal to the Portuguese names described in the API documentation.
  class SalesOrder < Omie::BaseResource
    CALLS = {
      list: 'ListarPedidos',
      create: 'IncluirPedido',
      update: 'AlterarPedidoVenda',
      find: 'ConsultarPedido',
      change_status: 'TrocarEtapaPedido',
      status: 'StatusPedido'
    }.freeze

    URI = '/v1/produtos/pedido/'

    attr_accessor :cabecalho, :det, :frete, :informacoes_adicionais, :lista_parcelas, :total_pedido

    def self.update(params = {})
      request_and_initialize(URI, CALLS[:update], params)
    end

    def self.create(params = {})
      request_and_initialize(URI, CALLS[:create], params)
    end

    def self.find(params)
      response = request(URI, CALLS[:find], params)
      Omie::SalesOrder.new(response['pedido_venda_produto'])
    rescue Omie::RequestError
      nil
    end

    def self.list(page = 1, per_page = 50)
      params = { pagina: page, registros_por_pagina: per_page }

      response = request(URI, CALLS[:list], params)
      response['pedido_venda_produto'].map { |sale_order| Omie::SalesOrder.new(sale_order) }
    rescue Omie::RequestError
      []
    end

    def self.change_status(integration_code, stage)
      params = { codigo_pedido_integracao: integration_code, etapa: stage }
      request_and_initialize(URI, CALLS[:change_status], params)
    end

    def self.status(integration_code)
      params = { codigo_pedido_integracao: integration_code }
      request_and_initialize(URI, CALLS[:change_status], params)
    end
  end
end
