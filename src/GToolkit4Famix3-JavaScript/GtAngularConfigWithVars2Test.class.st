Class {
	#name : #GtAngularConfigWithVars2Test,
	#superclass : #GtAngularImporterTest,
	#category : #'GToolkit4Famix3-JavaScript-Tests'
}

{ #category : #accessing }
GtAngularConfigWithVars2Test >> moduleA [
	^ 'angular.module(''moduleA'', [])

    .config(function config($routeProvider) {
        var missingPage = {
            templateUrl: ''template1.html'',
            controller: function ($route) {
                var ctrl = this;
                ctrl.partner = { partnerId: $route.current.params.id };
            },
            controllerAs: ''ctrl''
        };
        var partnerPage = {
            templateUrl: ''template2.html'',
            controller: ''PartnerUebersichtPageCtrl'',
            controllerAs: ''ctrl'',
            resolve: {
                vvnresolve: function (VvnRoute) {
                    return VvnRoute.init();
                },
                angebotIds: angebotIds,
                geschaeftsnummern: geschaeftsnummern,
                partner: partner
            }
        };
        var vertraegePage = {
            templateUrl: ''pdv/vertraegeUebersicht.page.tpl.html'',
            controller: ''VertraegeUebersichtPageCtrl'',
            controllerAs: ''ctrl'',
            resolve: {
                angebotIds: angebotIds,
                geschaeftsnummern: geschaeftsnummern,
                partner: partner
            }
        };

        $routeProvider
            .when(''/tmp/partneruebersicht/:id'', partnerPage)
            .when(''/tmp/partner/:id/partnerBeziehungen'', missingPage)
            .when(''/tmp/partner/:id/vertraege'', vertraegePage);
    })'
]

{ #category : #accessing }
GtAngularConfigWithVars2Test >> samples [
	^ #(moduleA)
]

{ #category : #testing }
GtAngularConfigWithVars2Test >> testModuleA [
	| moduleA |
	moduleA := importer targetModel allAngularModules entityNamed: 'moduleA'.
	self assert: moduleA components size equals: 4.
	self assert: (moduleA components anySatisfy: [ :c | c template name = 'template1.html' ]).
]

{ #category : #testing }
GtAngularConfigWithVars2Test >> testModules [
	self assert: importer targetModel allAngularModules size equals: 1
]
