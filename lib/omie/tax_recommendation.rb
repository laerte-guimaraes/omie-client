# frozen_string_literal: true

module Omie
  # This class abstracts tax recommendations related to the Product resource
  # from Omie (Ref: Produto). It works as an embedded object inside Product
  # payload. Take a look at this link for more details:
  # {https://app.omie.com.br/api/v1/geral/produtos/}.
  #
  # Different from traditional resources that inherit from {Omie::BaseResource},
  # internal objects does nothing but declares attributes that will comprise
  # a higher level resource's payload. They usually does not have specific
  # endpoints.
  class TaxRecommendation < Omie::BaseResource
    attr_accessor :origem_mercadoria, :id_preco_tabelado, :id_cest,
                  :cupom_fiscal, :market_place, :indicador_escala,
                  :cnpj_fabricante
  end
end
