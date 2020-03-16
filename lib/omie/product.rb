# frozen_string_literal: true

module Omie
  # This class abstracts the product resource from Omie (Ref: Produto)
  # It aims at providing abstractions to the endpoints described in
  # {https://app.omie.com.br/api/v1/geral/produtos/}.
  #
  # The class methods of Omie::Product usually performs requests to Omie API and
  # manipulate product objects that contain the returned values.
  # Attributes' names are equal to the Portuguese names described in the API
  # documentation.
  class Product < Omie::BaseResource
    CALLS = {
      list: 'ListarProdutos',
      create: 'IncluirProduto',
      update: 'AlterarProduto',
      find: 'ConsultarProduto',
      delete: 'ExcluirProduto',
      simple: 'UpsertProduto'
    }.freeze

    URI = '/v1/geral/produtos/'

    attr_accessor :ncm, :valor_unitario, :unidade, :descricao_status
    attr_accessor :codigo_produto_integracao, :codigo_produto, :descricao

    # Record a new product using the
    # {https://app.omie.com.br/api/v1/geral/produtos/#IncluirProduto
    # IncluirProduto} call and returns an instance of Omie::Product
    # with the data from the created product.
    #
    # @!scope class
    # @param params [Hash]
    #   a hash containing the data to be recorded in the product based on
    #   the available attributes of this class
    # @return [Omie::Product]
    #   the created product
    # @raise [Omie::RequestError]
    #   in case of failed requests due to failed validations
    def self.create(params = {})
      connection_ininitalize(URI, CALLS[:create], params)
    end

    # Update an existing product using the
    # {https://app.omie.com.br/api/v1/geral/produtos/#AlterarProduto
    # AlterarProduto} call and returns an instance of the updated product.
    # Omie will use either the {#codigo_produto_integracao} or the
    # {#codigo_produto} to identify the entry to be changed. It will
    # change only the informed attributes in params.
    #
    # @!scope class
    # @param params [Hash]
    #   a hash containing the search attribute to locate the product and
    #   the attributes/values to be updated.
    # @return [Omie::Product]
    #   the updated product
    # @raise [Omie::RequestError]
    #   in case of failed requests due to failed validations or when the
    #   product was not found.
    def self.update(params = {})
      connection_ininitalize(URI, CALLS[:update], params)
    end

    # Search for a product using the
    # {https://app.omie.com.br/api/v1/geral/produtos/#ConsultarProduto
    # ConsultarProduto} call and returns an instance of the found product
    # or nil otherwise.
    # One may use either the {#codigo_cliente_omie} or
    # {#codigo_cliente_integracao} to search for product
    #
    # @!scope class
    # @param params [Hash]
    #   a hash containing the search attribute to locate the product
    # @return [Omie::Product]
    #   the found product
    # @return [nil]
    #   in case of no product found
    def self.find(params)
      connection_ininitalize(URI, CALLS[:find], params)
    rescue Omie::RequestError
      nil
    end

    # Get a paginated list of companies recorded in Omie by using the
    # {https://app.omie.com.br/api/v1/geral/produtos/#ListarProdutos
    # Listarprodutos}. You may change the params to get other pages of
    # records.
    #
    # @!scope class
    # @param page [Integer]
    #   the page to be returned.
    # @param per_page [Integer]
    #   the number of items per page (max: 50).
    # @return [Array<Omie::Product>]
    #   the list of found companies
    def self.list(page = 1, per_page = 50)
      params = { pagina: page, registros_por_pagina: per_page }

      response = connection(URI, CALLS[:list], params)
      response['produto_servico_cadastro'].map do |product|
        Omie::Product.new(product)
      end
    rescue Omie::RequestError
      []
    end

    # Save the product.
    #
    # If the product is new a record is created on Omie, otherwise
    # the existing record gets updated.
    #
    # @return [Omie::Product]
    #   the product itself updated
    def save
      product = if saved?
                  Omie::Product.update(as_json)
                else
                  Omie::Product.create(as_json)
                end

      self.codigo_produto = product.codigo_produto if product
      product
    end

    # Check whether the object has a related record on Omie based on the
    # {#codigo_produto} attribute
    #
    # @return [Boolean]
    def saved?
      !codigo_produto.blank?
    end
  end
end
