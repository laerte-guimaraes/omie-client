# frozen_string_literal: true

require 'cpf_cnpj'

FactoryBot.define do
  factory :omie_company_data, class: Hash do
    codigo_cliente_integracao { SecureRandom.alphanumeric(8).upcase }
    cnpj_cpf { CNPJ.generate }
    nome_fantasia { 'Random' }
    razao_social { 'Random Company' }
    email { 'random@company.com' }
    codigo_cliente_omie { 123_456 }
    contato { '(11) 99999-9999' }

    initialize_with { attributes }
  end

  factory :json_api_company, class: Hash do
    data do
      {
        'id' => '5df9164ffd952400010d656e',
        'type' => 'companies',
        'attributes' => {
          'created-at' => '2019-12-17 17:54:23 UTC',
          'updated-at' => '2019-12-17 17:54:25 have_attributesUTC',
          'is-manufacturer' => false,
          'is-client' => false,
          'became-manufacturer-at' => nil,
          'became-client-at' => nil,
          'experimental' => false,
          'cnpj' => '23301943000150',
          'formatted-cnpj' => '23.301.943/0001-50',
          'name' => 'WEWORK SERVICOS DE ESCRITORIO LTDA.',
          'completed' => true, 'company-type' => 'MATRIZ',
          'opening-date' => '2015-09-17',
          'fantasy-name' => 'WEWORK',
          'legal-nature' => '206-2 - Sociedade Empresária Limitada',
          'email' => 'faturamento@wework.com',
          'phone-number' => '(11) 4950-5777',
          'efr' => '',
          'share-capital' => 550_000_000.0,
          'public-place' => 'AV PAULISTA 1374',
          'number' => 1374,
          'complement' => 'ANDAR 4 ANDAR 5 ANDAR 6 ANDAR 11 ANDAR 12',
          'zip-code' => '01.310-937',
          'neighborhood' => 'BELA VISTA',
          'city' => 'SAO PAULO',
          'uf' => 'SP',
          'latitude' => -23.5626894,
          'longitude' => -46.6544667,
          'address' => '1374, AV PAULISTA 1374, SAO PAULO, São Paulo, Brasil',
          'tax-profile-answered' => false,
          'manufacturer-profile-answered' => false,
          'can-receive-estimates' => true
        },
        'relationships' => {
          'primary-activity' => {
            'data' => {
              'id' => '5df913e8f7636c0001fbdb46',
              'type' => 'business-activities'
            }
          },
          'configuration' => {
            'data' => {
              'id' => '5df9164ff7636c0001fbdb86',
              'type' => 'manufacturer-profiles'
            }
          },
          'tax-profile' => {
            'data' => {
              'id' => '5df9164ff7636c0001fbdb88',
              'type' => 'tax-profiles'
            }
          },
          'secondary-activities' => {
            'data' => []
          }
        }
      }
    end
    initialize_with do
      data = {}
      data['data'] = attributes[:data]
      data
    end
  end
end
