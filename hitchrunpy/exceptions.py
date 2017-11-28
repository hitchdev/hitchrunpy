class HitchRunPyException(Exception):
    pass


class UnexpectedException(HitchRunPyException):
    """
    An unexpected exception was raised.
    """
    def __init__(self, exception_type, message, formatted_stacktrace):
        self.exception_type = exception_type
        self.message = message
        self.formatted_stacktrace = formatted_stacktrace
        super(HitchRunPyException, self).__init__((
            u"Unexpected exception '{0}' raised. Stacktrace:\n{1}"
        ).format(
            self.exception_type,
            self.formatted_stacktrace,
        ))


class ExpectedExceptionWasDifferent(HitchRunPyException):
    """
    The different exception was raised to the one expected.
    """
    def __init__(self, expected_exception, actual_exception, formatted_stacktrace):
        self.expected_exception = expected_exception
        self.actual_exception = actual_exception
        self.formatted_stacktrace = formatted_stacktrace
        super(HitchRunPyException, self).__init__((
            u"Expected exception '{0}', instead "
            u"'{1}' was raised:\n{2}"
        ).format(
            self.expected_exception,
            self.actual_exception,
            self.formatted_stacktrace,
        ))


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


class ExceptionDoesNotMatchFunction(HitchRunPyException):
    """Matching function did not return True."""
    def __init__(self, exception_type, message):
        self.exception_type = exception_type
        self.message = message
        super(ExceptionDoesNotMatchFunction, self).__init__((
            u"Exception '{0}' did not match function supplied. Message:\n{1}"
        ).format(
            self.exception_type,
            self.message,
        ))


class PythonTimeout(HitchRunPyException):
    pass


class ExpectedExceptionButNoExceptionOccurred(HitchRunPyException):
    pass


class OutputAppearsDifferent(HitchRunPyException):
    pass


class ErrorRunningCode(HitchRunPyException):
    pass
