class HitchRunPyException(Exception):
    pass


class UnexpectedException(HitchRunPyException):
    pass


class ExpectedExceptionWasDifferent(HitchRunPyException):
    pass


class ExpectedExceptionMessageWasDifferent(HitchRunPyException):
    pass


class ExpectedExceptionButNoExceptionOccurred(HitchRunPyException):
    pass


class NotEqual(HitchRunPyException):
    pass


class OutputAppearsDifferent(HitchRunPyException):
    pass
