Feature: Declaring and Satisfying Dependencies

  Scenario: Satisfying a dependency with a singleton
    Given I have a factory with a named dependency
    When I satisfy the named dependency with a singleton
    And I call the factory
    Then the factory should receive the singleton instance of its dependency

  Scenario: Satisfying a dependency with a factory
    Given I have a factory with a named dependency
    When I satisfy the named dependency with another factory that has no dependencies
    And I call the factory
    Then the factory should receive an instance created by the dependency factory

  Scenario: Transitively satisfying dependencies
    Given I have a factory with a named dependency
    When I satisfy the named dependency with another factory that has a dependency
    And I satisfy that dependency with a singleton
    And I call the factory
    Then the dependency factory should receive the singleton instance of its dependency
    And the factory should receive an instance created by the dependency factory

  Scenario: Raising an error when dependencies are not satisfied
    Given I have a factory with a named dependency
    When I satisfy the named dependency with another factory that has a dependency
    And I call the factory
    Then an unmet dependency error should be raised for the transitive depenency

  Scenario: Satisfying dependencies for curried factories
    Given I have a curried factory with a named dependency
    When I satisfy the named dependency with a singleton
    And I call the factory
    And I call the returned proc with additional arguments
    Then the factory should receive the singleton dependency and the additional arguments
