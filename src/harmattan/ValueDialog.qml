import QtQuick 1.1
import com.nokia.meego 1.0
import org.marxoft.cuteradio 1.0

SelectionDialog {
    id: root

    property string name
    property variant value

    onAccepted: {
        name = model.name(selectedIndex);
        value = model.value(selectedIndex);
    }

    onStatusChanged:  {
        if (status === DialogStatus.Opening) {
            for (var i = 0; i < model.count; i++) {
                if (model.value(i) === value) {
                    name = model.name(i);
                    selectedIndex = i;

                    return;
                }
            }
        }
    }
}
