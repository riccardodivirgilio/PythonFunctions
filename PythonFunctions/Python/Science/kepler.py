import lightkurve


def entrypoint(obj):
    return (
        [x.time.value, x.flux.value] for x in lightkurve.search_lightcurve(obj).download_all()
    )
