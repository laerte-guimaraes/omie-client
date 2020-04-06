# frozen_string_literal: true

FactoryBot.define do
  factory :omie_tax_recommendation_data, class: Hash do
    origem_mercadoria { '1' }
    id_cest { '' }
    id_preco_tabelado { '' }
    cupom_fiscal { 'N' }
    market_place { '' }
    indicador_escala { '' }
    cnpj_fabricante { '' }
    initialize_with { attributes }
  end
end
