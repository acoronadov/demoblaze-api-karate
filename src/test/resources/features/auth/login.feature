@api @login
Feature: Servicio de autenticación en DemoBlaze

  Background:
    * def user = call read('classpath:features/helpers/create-user.feature')
    Given url baseUrl
    And path 'login'

  @positive @smoke
  Scenario: Login con usuario y password correctos
    And request { username: '#(user.username)', password: '#(user.password)' }
    When method post
    Then status 200
    And match response == '#string'
    And match response contains 'Auth_token:'

  @negative
  Scenario: Login con password incorrecto
    * def wrongPassword = read('classpath:data/users.json').wrongPassword
    And request { username: '#(user.username)', password: '#(wrongPassword)' }
    When method post
    Then status 200
    And match response.errorMessage == 'Wrong password.'
