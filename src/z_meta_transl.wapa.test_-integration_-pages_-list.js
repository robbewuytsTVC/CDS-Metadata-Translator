sap.ui.define(["sap/ui/test/Opa5","sap/ui/test/actions/Press","./Common","sap/ui/test/actions/EnterText","sap/ui/test/matchers/AggregationLengthEquals","sap/ui/test/matchers/AggregationFilled","sap/ui/test/matchers/PropertyStrictEquals"],function(e,t,i,s+
,r,n,a){"use strict";var o="List";e.createPageObjects({onTheMasterPage:{baseClass:i,actions:{iRememberTheIdOfListItemAtPosition:function(e){return this.waitFor({id:"list",viewName:o,matchers:function(t){return t.getItems()[e]},success:function(e){this.iR+
ememberTheListItem(e)},errorMessage:"The list does not have an item at the index "+e})},iPressOnTheObjectAtPosition:function(e){return this.waitFor({id:"list",viewName:o,matchers:function(t){return t.getItems()[e]},actions:new t,errorMessage:"List 'list'+
 in view '"+o+"' does not contain an ObjectListItem at position '"+e+"'"})},iSearchForTheFirstObject:function(){var e;return this.waitFor({id:"list",viewName:o,matchers:new n({name:"items"}),success:function(i){e=i.getItems()[0].getTitle();return this.iS+
earchForValue(new s({text:e}),new t)},errorMessage:"Did not find list items while trying to search for the first item."})},iSearchForValue:function(e){return this.waitFor({id:"searchField",viewName:o,actions:e,errorMessage:"Failed to find search field in+
 List view.'"})},iClearTheSearch:function(){var e=function(e){e.clear()};return this.iSearchForValue([e])},iRememberTheListItem:function(e){var t=e.getBindingContext();this.getContext().currentItem={bindingPath:t.getPath(),id:t.getProperty("Ddlxname"),ti+
tle:t.getProperty("Ddlxname")}}},assertions:{iShouldSeeTheList:function(){return this.waitFor({id:"list",viewName:o,success:function(t){e.assert.ok(t,"Found the object List")},errorMessage:"Can't see the list."})},theListShowsOnlyObjectsWithTheSearchStri+
ngInTheirTitle:function(){this.waitFor({id:"list",viewName:o,matchers:new n({name:"items"}),check:function(e){var t=e.getItems()[0].getTitle(),i=e.getItems().every(function(e){return e.getTitle().indexOf(t)!==-1});return i},success:function(t){e.assert.o+
k(true,"Every item did contain the title")},errorMessage:"The list did not have items"})},iShouldSeeTheNoDataTextForNoSearchResults:function(){return this.waitFor({id:"list",viewName:o,success:function(t){e.assert.strictEqual(t.getNoDataText(),t.getModel+
("i18n").getProperty("masterListNoDataWithFilterOrSearchText"),"the list should show the no data text for search and filter")},errorMessage:"list does not show the no data text for search and filter"})},theListShouldHaveNoSelection:function(){return this+
.waitFor({id:"list",viewName:o,matchers:function(e){return!e.getSelectedItem()},success:function(t){e.assert.strictEqual(t.getSelectedItems().length,0,"The list selection is removed")},errorMessage:"List selection was not removed"})}}}})});               