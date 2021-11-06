Feature: Find tag value under point
   Background:
     Given I switch to buffer "*find-tag*"
     And I clear the buffer
     And I bind key "C-c c" to "auto-close-tag"

  Scenario: Close tag without props
    When I insert:
    """
    <div
    """
    And I press "C-c c"
    Then I should see:
    """
    <div></div>
    """

  Scenario: Close tag with props
    When I insert:
    """
    <div props={myProps}
    """
    And I press "C-c c"
    Then I should see:
    """
    <div props={myProps}></div>
    """

  Scenario: Close last tag
    When I insert:
    """
    <span><div props={myProps}
    """
    And I press "C-c c"
    Then I should see:
    """
    <span><div props={myProps}></div>
    """

  Scenario: No tag
    When I insert:
    """
    there is no tag on this line.
    """
    And I press "C-c c"
    Then I should see:
    """
    there is no tag on this line.
    """

  Scenario: Closing tag
    When I insert:
    """
    <tag /
    """
    And I press "C-c c"
    Then I should see:
    """
    <tag />
    """

  Scenario: Current tag is already closed
    When I insert:
    """
    <tag>
    """
    And I press "C-c c"
    Then I should see:
    """
    <tag></tag>
    """