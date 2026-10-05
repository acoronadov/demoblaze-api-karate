@ignore
Feature: Preparar un usuario nuevo para cada escenario

  Scenario: Registrar un usuario único
    * def username = 'alexqa_' + java.util.UUID.randomUUID().toString()
    * def password = read('classpath:data/users.json').defaultPassword
    Given url baseUrl
    And path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    * def signupResponse = JSON.parse(response)
    And match signupResponse == ''
