import { CommonConstant as Comm } from '../common/Constants'
import { NavigatorModel } from '../viewmodel/NavigatorModel'

@Extend(Button) function fancy(top: string) {
    .fontSize(Comm.MainConstant_BUTTON_FONT_SIZE)
    .fontColor($r('app.color.start_window_background'))
    .width(Comm.WebConstant_BUTTON_WIDTH)
    .height(Comm.MainConstant_BUTTON_HEIGHT)
    .margin({ top: top })
    .backgroundColor($r('app.color.blue'))
    .borderRadius(Comm.MainConstant_BUTTON_BORDER_RADIUS)

}

@Entry
@Component
struct Index {
    build() {
        Column() {
            Image($r('app.media.background'))
                .width(Comm.MainConstant_FULL_HEIGHT)
                .height(Comm.MainConstant_IMAGE_HEIGHT)
            Navigator({ target: Comm.WEB_PAGE_URI, type: NavigationType.Push }) {
                Button($r('app.string.loadLocalH5'))
                    .fancy(Comm.MainConstant_BUTTON_MARGIN_TOP)
            }
            .params({
                path: Comm.LOCAL_PATH, tips: $r('app.string.local')
            } as NavigatorModel)

            Navigator({ target: Comm.WEB_PAGE_URI, type: NavigationType.Push }) {
                Button($r('app.string.loadCloudH5'))
                    .fancy(Comm.MainConstant_BUTTON_MARGIN_TOP_BUTTON)
            }
            .params({ path: Comm.CLOUD_PATH, tips: $r('app.string.online') } as NavigatorModel)

        }
        .height(Comm.MainConstant_FULL_HEIGHT)
        .backgroundColor($r('app.color.navy_blue'))
    }
}

