
$(document).ready(function() {

  var classNames = ["OAStackView", "TZStackView", "FDStackView"];

  var maxFailures = 10;

  var keysAndValues = null;
  var stackViewResultsData = {};


  // setup the parameter checkboxes
  var initializeParameters = function(d) {
    if (keysAndValues != null) {
      return;
    }

    keysAndValues = {};

    var keys = Object.keys(d[0]).sort();
    delete keys[keys.indexOf("success")];

    // Setup data storage
    keys.forEach(function(k) {
      keysAndValues[k] = [];
    });

    d.forEach(function(element, i) {
      keys.forEach(function(k) {
        var val = element[k];
        if (keysAndValues[k].indexOf(val) < 0) {
          keysAndValues[k].push(val);
        }
      });
    });


    // Create column for each parameter type
    $.each(keysAndValues, function(category, values) {

      // Create the container column
      var div = $("<td/>", {id: category, valign: "top"});
      $('#value_select').append(div);


      // Shorten the string displayed
      var categoryString = category;
      if (categoryString === "baselineRelativeArrangement") {
        categoryString = "baselineArr.";
      }
      else if (categoryString === "layoutMarginRelativeArrangement") {
        categoryString = "layoutMarginArr.";
      }

      var header = $("<td/>", {title: category}).text(categoryString);
      $('#value_select_header').append(header);

      values.sort();

      // Add checkbox for each parameter
      $.each(values, function(i, key) {
        var label = $("<label/>", {class: "parameter_label"}).text(key);
        label.prepend($("<input>", {type: "checkbox", id: category + i, "checked": true}).text(key));
        div.append(label);
        div.append($("<br/>"));
      });
    });

    // Register event that will update the displayed values
    $("input[type=checkbox]").change(function() {
      updateValues();
    });
  };

  // Update the results values in the table
  var updateValues = function() {

    // Get the list of allowed keys that should be included with the filter
    var allowedKeys = {};
    $.each(keysAndValues, function(category, values) {
      allowedKeys[category] = [];

      $.each(values, function(i, key) {
        if ($("#" + category + i).prop("checked")) {
          allowedKeys[category].push(key);
        }
      });
    });


    // Update the result information for a class
    var updateResults = function(className) {

      var resultsRow = $("#" + className + "_results_row");
      var allData = stackViewResultsData[className];
      if (allData == null) {
        return;
      }

      var success = 0;
      var total = 0;
      var failureData = [];

      // Filter out the data that is excluded
      $.each(allData, function(i, data) {
        for (category in keysAndValues) {
          if (allowedKeys[category].indexOf(data[category]) < 0) {
            return;
          }
        }

        // Count the successes
        total++;
        if (data["success"]) {
          success++;
        }
        else {
          failureData.push(data);
        }
      });

      // Update the data
      resultsRow.find('.results_breakdown').text(success + "/" + total);
      var percentage = resultsRow.find('.results_percentage');

      if (total > 0) {
        percentage.text((success / total * 100).toFixed(1) + "%");
      }
      else {
        percentage.text("");
      }

      // Generate markdown version
      var line = "| " + resultsRow.find('.table_header').text();
      line += " | " + resultsRow.find('.results_breakdown').text();
      line += " | " + percentage.text() + " |";

      $("#markdown_results").text($("#markdown_results").text() + line + "\n");


      // Update the failure parameters section
      var failureSection = $("#" + className + "_failure_params");
      failureSection.empty();
      $.each(failureData, function(i, data) {
        if (i >= maxFailures) {
          return false;
        }
        var div = $("<div/>").append($("<pre/>").text(JSON.stringify(data, null, 2)));
        failureSection.append(div);
      });
    }

    // Reset the markdown and initiate with a header
    var mdHeader = "| Class | Breakdown | Percentage |\n|-------|-----------|------------|\n";
    $("#markdown_results").text(mdHeader);

    // Actually update results for each section
    classNames.forEach(function(className) {
      updateResults(className);
    });
  }

  $("#update_button").click(updateValues);
  $("#reset_button").click(function() {
    $("input[type=checkbox]").prop("checked", true);
    updateValues();
  });

  // Setup DOM with elements
  classNames.forEach(function(className) {
    // Results row
    {
      var tr = $("<tr/>", {id: className + "_results_row"});
      tr.append($("<td/>", {class: "table_header"}).text(className));
      tr.append($("<td/>", {class: "results_breakdown"}));
      tr.append($("<td/>", {class: "results_percentage"}));

      $("#results_table_body").append(tr);
    }

    // Failure input
    {
      var input = $("<input/>", {type: "radio", name: "stackview_failures", value: className});
      var label = $("<label/>").text(className);
      label.prepend(input);
      var div = $("<div/>");
      div.append(label);

      $("#failures_input").append(div);
    }

    // Error Parameters
    {
      var div = $("<div/>", {id: className + "_failure_params"});
      div.hide();
      $("#error_parameters").append(div);
    }
  });

  $("input[type=radio][name=stackview_failures]").change(function() {

    $("#error_parameters").children().hide();
    $("#" + $(this).val() + "_failure_params").show();
  });


  // Retrieve metadata
  classNames.forEach(function(className) {
    $.getJSON("metadata/VTExhaustiveTests/metadata_" + className, function(d) {
        stackViewResultsData[className] = d;
        initializeParameters(d);
        updateValues();
    });
  });
});
