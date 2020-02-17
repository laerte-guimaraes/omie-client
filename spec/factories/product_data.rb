# frozen_string_literal: true

FactoryBot.define do
  factory :omie_product_data, class: Hash do
    codigo_produto_integracao { SecureRandom.alphanumeric(8).upcase }
    codigo_produto { rand(10 ** 10) }
    descricao { 'Produto de teste' }
    unidade { 'UN' }
    ncm { '84799090' }
    valor_unitario { 200 }

    initialize_with { attributes }
  end
end