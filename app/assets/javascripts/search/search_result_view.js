jQuery(document).ready(function($) {
	"use strict";
	var body = $("body");


	function createTotals(total) {
		$("#search_result_count").text("Search Results (" + window.collex.number_with_delimiter(total)+")");
	}

	function setFederations(federations, selected) {
		var federationCounts = $(".limit_to_federation .num_objects");
		federationCounts.each(function(index, el) {
			el = $(el);
			var fed = el.attr("data-federation");
			if (federations[fed])
				el.text(window.collex.number_with_delimiter(federations[fed]));
			else
				el.text("");
		});
		var federationChecks = $(".limit_to_federation input");
		if (!selected)
			federationChecks.prop('checked', true);
		else {
			federationChecks.each(function(index, el) {
				var name = el.name;
				$(el).prop('checked', selected[name]);
			});
		}
	}

	function isEmptyObject(obj) {
		for (var key in obj) {
			if (obj.hasOwnProperty(key)) {
				return false;
			}
		}
		return true;
	}

	function showResultSections(obj) {
		if (isEmptyObject(obj.query)) {
			// this is a blank page, with no search.
			$(".has-results").hide();
			$(".add_constraint_form").show();
		} else {
			$(".add_constraint_form").hide();
			$(".has-results").show();
			if (obj.hits.length === 0) {
				// there was a search, but there were no results.
				$(".not-empty").hide();
				$(".no_results_msg").show();
			} else {
				// there was a search, and it returned some results.
				$(".not-empty").show();
				$(".no_results_msg").hide();
			}
		}
	}

	function showMessage(message) {
		var el = $(".search_error_message");
		el.text(message);
		if (message && message.length > 0)
			el.show();
		else
			el.hide();
	}

	function fixExpandAllLink() {
		$("#expand_all").show();
		$("#collapse_all").hide();
	}

	var timeoutHandle;
	function imageTimeout() {
		timeoutHandle = setTimeout(function() {
			var spinners = $('.progress_timeout');
			spinners.each(function(index, spinner) {
				spinner.src = $(spinner).attr('data-noimage');
			});
			timeoutHandle = null;
		}, 8000);
	}

	// has-results add_constraint_form not-empty no_results_msg
	body.bind('RedrawSearchResults', function(ev, obj) {
		if (!obj || !obj.hits || !obj.facets || !obj.query) {
			window.console.log("error redrawing search results", obj);
			return;
		}

		if (timeoutHandle) {
			clearTimeout(timeoutHandle);
			timeoutHandle = null;
		}

		showResultSections(obj);
		showMessage(obj.message);

		window.collex.createResultRows(obj);

		window.collex.createSearchForm(obj.query);
		window.collex.createFacets(obj);

		var page = obj.query.page ? obj.query.page : 1;
		window.collex.createPagination(page, obj.total_hits, obj.page_size);

		createTotals(obj.total_hits);
		setFederations(obj.facets.federation, obj.query.f);
		fixExpandAllLink();

		imageTimeout();
	});
});
