describe "Airframe", ->

    beforeEach( ->
        
        @fcis = new Jetdeck.Collections.AirframesCollection()
        @fci = new Jetdeck.Models.Airframe()
        @fci.collection = @fcis
        
    )
        
    it "collection should have a url", ->
        expect(@fcis.url).toEqual('/fcis')
        
    it "model should be defined", ->
        expect(Nghud.Models.Fci).toBeDefined()
        
    it "model should have default values", ->
        expect(@fci.get('title')).toBeDefined()
        
    it "collection have more than 100 FCIs when fetched", ->
        callback = jasmine.createSpy("FCI Fetch Callback")
        
        @fcis.fetch({ success: callback })
        
        waitsFor(  -> 
            return (callback.callCount > 0)
        , "cannot fetch FCIs", 3000)
        
        runs( ->
            expect(callback).toHaveBeenCalled()
            expect(callback.mostRecentCall.args[0].length).toBeGreaterThan(100)
        )
        
    it "can be created and destroyed on server", ->

        fcis = new Nghud.Collections.FcisCollection()
        fci = new Nghud.Models.Fci()
        fci.collection = fcis
        fci.set('title', 'TEST FCI')  
    
        successResponse = jasmine.createSpy("FCI XHR success response") 
        failureResponse = jasmine.createSpy("FCI XHR failure response") 
            
        runs( ->
        
            fcis.create(fci, {success: successResponse, error: failureResponse})
            
        )
        
        waitsFor( ->
            return (
                successResponse.callCount > 0
            )
        , "did not receive model in response to create()", 3000)
        
        runs( ->
        
            expect(successResponse.mostRecentCall.args[0].get("title")).toEqual(
                fci.get('title')
            )

            fci.destroy({success: successResponse, error: failureResponse})   
            
        )

        waitsFor( ->
            return (
                successResponse.callCount > 1
            )
        , "did not receive model in response to destroy()", 3000)            
