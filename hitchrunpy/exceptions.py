class HitchRunPyException(Exception):
    pass


class UnexpectedException(HitchRunPyException):
    pass


class ExpectedExceptionWasDifferent(HitchRunPyException):
    pass


class ExpectedExceptionMessageWasDifferent(HitchRunPyException):
    """
    The correct exception was raised, but its message was not as expected.
    """
    def __init__(self, exception_type, actual_message, expected_message, diff):
        self.exception_type = exception_type
        self.actual_message = actual_message
        self.expected_message = expected_message
        self.diff = diff
        super(HitchRunPyException, self).__init__((
            u"Expected exception '{0}' was raised, but message was different.\n"
            u"\n"
            u"ACTUAL:\n"
            u"{1}\n"
            u"\n"
            u"EXPECTED:\n"
            u"{2}\n"
            u"DIFF:\n"
            u"{3}"
        ).format(
            self.exception_type,
            self.actual_message,
            self.expected_message,
            self.diff,
        ))


class ExpectedExceptionButNoExceptionOccurred(HitchRunPyException):
    pass


class NotEqual(HitchRunPyException):
    pass


class OutputAppearsDifferent(HitchRunPyException):
    pass


class ErrorRunningCode(HitchRunPyException):
    pass
