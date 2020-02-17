# frozen_string_literal: true

require 'active_support/core_ext'

module Omie
  # This class abstracts the Company resource from Omie (Ref: Cliente) which
  # is used for all kinds of companies in Omie, mainly Clients and Suppliers.
  # It aims at providing abstractions to the endpoints described in
  # {https://app.omie.com.br/api/v1/geral/clientes/}.
  #
  # The class methods of Omie::Company usually perform requests to Omie API and
  # manipulate Company objects that contain the returned values.
  # Attributes' names are equal to the Portuguese names described in the API
  # documentation.
  class Company < Omie::BaseResource
    CALLS = {
      list: 'ListarClientes',
      create: 'IncluirCliente',
      update: 'AlterarCliente',
      find: 'ConsultarCliente',
      delete: 'ExcluirCliente',
      upsert: 'UpsertCliente'
    }.freeze

    URI = '/v1/geral/clientes/'

    attr_accessor :email, :cnpj_cpf, :razao_social, :contato, :nome_fantasia
    attr_accessor :codigo_cliente_integracao, :codigo_cliente_omie, :endereco
    attr_accessor :cidade, :complemento, :estado, :endereco_numero, :cep
    attr_accessor :codigo_pais, :bairro, :inscricao_estadual

    # Record a new company using the
    # {https://app.omie.com.br/api/v1/geral/clientes/#IncluirCliente
    # IncluirCliente} call and returns an instance of Omie::Company
    # with the data from the created company.
    #
    # @!scope class
    # @param params [Hash]
    #   a hash containing the data to be recorded in the company based on
    #   the available attributes of this class
    # @return [Omie::Company]
    #   the created company
    # @raise [Omie::RequestError]
    #   in case of failed requests due to failed validations
    def self.create(params = {})
      connection_ininitalize(URI, CALLS[:create], params)
    end

    # Updates an existing company using the
    # {https://app.omie.com.br/api/v1/geral/clientes/#AlterarCliente
    # AlterarCliente} call and returns an instance of the updated company.
    # Omie will use either the {#codigo_cliente_integracao} or the
    # {#codigo_cliente_omie} to identify the entry to be changed. It will
    # change only the informed attributes in params.
    #
    # @!scope class
    # @param params [Hash]
    #   a hash containing the search attribute to locate the company and
    #   the attributes/values to be updated.
    # @return [Omie::Company]
    #   the updated company
    # @raise [Omie::RequestError]
    #   in case of failed requests due to failed validations or when the
    #   company was not found.
    def self.update(params = {})
      connection_ininitalize(URI, CALLS[:update], params)
    end

    # Search for a company using the
    # {https://app.omie.com.br/api/v1/geral/clientes/#ConsultarCliente
    # ConsultarCliente} call and returns an instance of the found company
    # or nil otherwise.
    # One may use either the {#codigo_cliente_omie} or
    # {#codigo_cliente_integracao} to search for company
    #
    # @!scope class
    # @param params [Hash]
    #   a hash containing the search attribute to locate the company
    # @return [Omie::Company]
    #   the found company
    # @return [nil]
    #   in case of no company found
    def self.find(params)
      connection_ininitalize(URI, CALLS[:find], params)
    rescue Omie::RequestError
      nil
    end

    # Get a paginated list of companies recorded in Omie by using the
    # {https://app.omie.com.br/api/v1/geral/clientes/#ListarClientes
    # ListarClientes}. You may change the params to get other pages of
    # records.
    #
    # @!scope class
    # @param page [Integer]
    #   the page to be returned.
    # @param per_page [Integer]
    #   the number of items per page (max: 50).
    # @return [Array<Omie::Company>]
    #   the list of found companies
    def self.list(page = 1, per_page = 50)
      params = { pagina: page, registros_por_pagina: per_page }

      response = connection(URI, CALLS[:list], params)
      response['clientes_cadastro'].map { |client| Omie::Company.new(client) }
    rescue Omie::RequestError
      []
    end

    # Get method for tags attribute.
    #
    # @return [Array<Hash>]
    #   list of hashes containing the tags' information with the following
    #   structure => {tag: "tag value"}
    def tags
      @tags ||= []
      @tags
    end

    # Set method for tags attribute to be used for mass assignment of
    # attribuites returned from Omie. It also sets {#tag_values}.
    def tags=(value)
      @tags = value
      @tag_values = @tags.map { |t| t[:tag] }
    end

    # Get method for tag_values attribute.
    #
    # @return [Array<String>]
    #   list containing only the values of {#tags}
    def tag_values
      @tag_values ||= []
      @tag_values
    end

    # Add a new tag method to formatted into Omie`s structure. It
    # does not duplicate entries.
    #
    # @return [Omie::Company]
    #   self instance
    def add_tag(tag = nil)
      if tag && !tag_values.include?(tag)
        tags << {
          tag: tag
        }
        tag_values << tag
      end
      self
    end

    # Save the company.
    #
    # If the company is new a record is created on Omie, otherwise
    # the existing record gets updated.
    #
    # @return [Omie::Company]
    #   the company itself updated
    def save
      company = if saved?
                  Omie::Company.update(as_json.except(['tag_values']))
                else
                  Omie::Company.create(as_json.except(['tag_values']))
                end

      self.codigo_cliente_omie = company.codigo_cliente_omie if company
      company
    end

    # Check whether the object has a related record on Omie based on the
    # {#codigo_cliente_omie} attribute
    #
    # @return [Boolean]
    def saved?
      !codigo_cliente_omie.blank?
    end
  end
end
