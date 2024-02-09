import lightkurve

def entrypoint(obj):
    return map( 
        lambda x: [x.time.value,x.flux.value], 
        lightkurve.search_lightcurve(obj).download_all() 
    )
