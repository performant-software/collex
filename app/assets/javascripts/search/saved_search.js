// ------------------------------------------------------------------------
//     Copyright 2009 Applied Research in Patacriticism and the University of Virginia
// 
//     Licensed under the Apache License, Version 2.0 (the "License");
//     you may not use this file except in compliance with the License.
//     You may obtain a copy of the License at
// 
//         http://www.apache.org/licenses/LICENSE-2.0
// 
//     Unless required by applicable law or agreed to in writing, software
//     distributed under the License is distributed on an "AS IS" BASIS,
//     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//     See the License for the specific language governing permissions and
//     limitations under the License.
// ----------------------------------------------------------------------------

/*global TextInputDlg */
/*extern showString, showHiddenSavedSearches */

function showString(str)
{
	new TextInputDlg({
		title: "Copy and Paste link into E-mail or IM",
		prompt: 'Link:',
		id: 'show_save_name',
		value: str,
		inputKlass: "saved_search_copy_el",
		body_style: "saved_search_copy_body",
		noOk: true
	});
	jQuery('#show_save_name').select();
}

function showHiddenSavedSearches(class_of_button, class_of_hidden_items)
{
	var cntl = jQuery('.' + class_of_button)[0];
	var hidden_items = jQuery('.' + class_of_hidden_items);
	var expand = (cntl.innerHTML === '[show all]');
	if (expand) {
		cntl.innerHTML = '[hide some]';
		hidden_items.each(function(item) {
			item.removeClassName('hidden');
		});
	} else {
		cntl.innerHTML = '[show all]';
		hidden_items.each(function(item) {
			item.addClassName('hidden');
		});
	}
}

function doSaveSearch()
{
	function onSuccess(resp) {
		var search = resp.responseJSON;
		window.collex.savedSearches.push({ name: search.name, url: search.url });
		window.collex.drawSavedSearch();
		window.collex.drawSavedSearchList();
	}

	new TextInputDlg({
		title: "Save Search",
		prompt: 'Name:',
		id: 'saved_search_name',
		okStr: 'Save',
		actions: "/search/save_search",
		target_els: "bit-bucket",
		pleaseWaitMsg: "Storing the current search...",
		extraParams: { query: encodeURIComponent(window.location.search.substr(1)) },
		onSuccess: onSuccess
	});
}

