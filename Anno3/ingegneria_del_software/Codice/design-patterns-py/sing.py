class singleton:
    __instances = {}
    def __call__(cls, *args, **kwargs):
