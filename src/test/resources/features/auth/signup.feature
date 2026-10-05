@api @signup
Feature: Servicio de registro de usuarios en DemoBlaze

  @positive @smoke
  Scenario: Crear un nuevo usuario
    * def user = call read('classpath:features/helpers/create-user.feature')
    Then match user.responseStatus == 200
    And match user.signupResponse == ''

  @negative
  Scenario: Intentar crear un usuario ya existente
    * def user = call read('classpath:features/helpers/create-user.feature')
    Given url baseUrl
    And path 'signup'
    And request { username: '#(user.username)', password: '#(user.password)' }
    When method post
    Then status 200
    And match response.errorMessage == 'This user already exist.'
