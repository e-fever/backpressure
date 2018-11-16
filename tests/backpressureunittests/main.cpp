#include <QString>
#include <QtTest>
#include <XBacktrace.h>
#include <TestRunner>
#include <QtQuickTest/quicktest.h>

namespace AutoTestRegister {
QUICK_TEST_MAIN(QuickTests)
}

int main(int argc, char *argv[])
{
    XBacktrace::enableBacktraceLogOnUnhandledException();

    QGuiApplication app(argc, argv);

    TestRunner runner;
    runner.addImportPath("qrc:///");
    runner.add(QString(SRCDIR) + "qmltests");

    bool error = runner.exec(app.arguments());

    if (!error) {
        qDebug() << "All test cases passed!";
    }

    return error;
}
