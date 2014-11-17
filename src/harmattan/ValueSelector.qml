import QtQuick 1.1
import com.nokia.meego 1.0
import org.marxoft.cuteradio 1.0

ValueListItem {
    id: root

    property variant value
    property variant model

    onClicked: {
        loader.sourceComponent = dialog;
        loader.item.open();
    }

    Loader {
        id: loader
    }

    Component {
        id: dialog

        ValueDialog {
            titleText: root.title
            model: root.model
            value: root.value
            onNameChanged: root.subTitle = name
            onValueChanged: root.value = value
        }
    }

    Component.onCompleted: {
        if (model) {
            for (var i = 0; i < model.count; i++) {
                if (model.value(i) === value) {
                    subTitle = model.name(i);

                    return;
                }
            }
        }
    }
}
