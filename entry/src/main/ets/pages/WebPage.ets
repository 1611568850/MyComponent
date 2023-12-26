import web_webview from '@ohos.web.webview'
import router from '@ohos.router'
import { CommonConstant } from '../common/Constants'
import { NavigatorModel } from '../viewmodel/NavigatorModel'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct WebPage {
    @State message: string = 'WebPage WebPage'
    @State params: object = router.getParams()
    webController: web_webview.WebviewController = new web_webview.WebviewController()
    @State intervalLoading: number = 0
    @State isLoading: boolean = true;
    @State progressVal: number = -1

    aboutToAppear() {
        this.intervalLoading = setInterval(() => {
            this.progressVal = this.progressVal >= CommonConstant.WebConstant_PROGRESS_MAX ?
            CommonConstant.WebConstant_PROGRESS_MIN : this.progressVal + CommonConstant.WebConstant_PROGRESS_STEP
        }, CommonConstant.WebConstant_MILLI_SECONDS)
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            Image($r('app.media.background'))
                .width(CommonConstant.WebConstant_FULL_WIDTH)
                .height(CommonConstant.MainConstant_IMAGE_HEIGHT)
            Row() {
                Column() {
                    Row() {
                        Image($rawfile('img/ic_public_back.png'))
                            .width(CommonConstant.WebConstant_IMAGE_WIDTH)
                            .height(CommonConstant.WebConstant_IMAGE_HEIGHT)
                            .margin({ left: CommonConstant.WebConstant_IMAGE_MARGIN_LEFT })
                        Text($r('app.string.prompts'))
                            .fontSize(CommonConstant.WebConstant_TOP_TEXT_FONT_SIZE)
                            .width(CommonConstant.WebConstant_TOP_TEXT_WIDTH)
                            .height(CommonConstant.WebConstant_TOP_TEXT_HEIGHT)
                            .fontColor($r('app.color.black'))
                            .margin({ left: CommonConstant.WebConstant_TOP_TEXT_MARGIN_LEFT })
                    }
                    .height(CommonConstant.WebConstant_TOP_ROW_HEIGHT)

                    Web({ src: this.params['path'], controller: this.webController })
                        .zoomAccess(false)
                        .width(CommonConstant.WebConstant_WIDTH)
                        .aspectRatio(1)
                        .margin({
                            left: CommonConstant.WebConstant_MARGIN_LEFT,
                            right: CommonConstant.WebConstant_MARGIN_RIGHT,
                            top: CommonConstant.WebConstant_MARGIN_TOP
                        })
                        .onConfirm((event) => {
                            AlertDialog.show({
                                message: CommonConstant.WEB_ALERT_DIALOG_TEXT_VALUE + event?.message,
                                confirm: {
                                    value: $r('app.string.web_alert_dialog_button_value'),
                                    action: () => {
                                        event?.result.handleConfirm()
                                    }
                                },
                                cancel: () => {
                                    event?.result.handleConfirm()
                                }

                            })
                            return true
                        })
                        .onProgressChange((event) => {
                            if (event?.newProgress === CommonConstant.WebConstant_PROGRESS_MAX) {
                                this.isLoading = false;
                                clearInterval(this.intervalLoading)
                                this.intervalLoading = -1
                            }
                        })
                        .onErrorReceive((event) => {
                            if (event?.error.getErrorInfo() === 'ERR_CONNECTION_REFUSED') {
                                promptAction.showToast({
                                    // @ts-ignore
                                    message: $r('app.string.internet_err'),
                                    duration: CommonConstant.WebConstant_DURATION
                                })
                            }
                            if (event?.error.getErrorInfo() === 'ERR_CONNECTION_TIMED_OUT') {
                                promptAction.showToast({
                                    message: $r('app.string.internet_err'),
                                    duration: CommonConstant.WebConstant_DURATION
                                })
                            }
                        })
                    Column() {
                        Text($r('app.string.textValue'))
                            .fontSize(CommonConstant.WebConstant_TEXT_VALUE_FONT_SIZE)
                            .textAlign(TextAlign.Center)
                            .fontColor($r('app.color.text_value_font_color'))
                            .height(CommonConstant.WebConstant_TEXT_VALUE_HEIGHT)
                            .fontWeight(CommonConstant.WebConstant_TEXT_VALUE_FONT_WEIGHT)
                            .margin({ top: CommonConstant.WebConstant_TEXT_VALUE_MARGIN_TOP })
                        Text(this.params['tips'])
                            .fontSize(CommonConstant.WebConstant_TIP_TEXT_VALUE_FONT_SIZE)
                            .textAlign(TextAlign.Center)
                            .fontColor($r('app.color.text_value_font_color'))
                            .width(CommonConstant.WebConstant_TIP_TEXT_VALUE_WIDTH)
                            .height(CommonConstant.WebConstant_TIP_TEXT_VALUE_HEIGHT)
                            .opacity(CommonConstant.WebConstant_TIP_TEXT_VALUE_OPACITY)
                            .margin({ top: CommonConstant.WebConstant_TIP_TEXT_VALUE_MARGIN_TOP })
                    }

                    Button($r('app.string.btnValue'))
                        .fontSize(CommonConstant.WebConstant_BUTTON_FONT_SIZE)
                        .fontColor($r('app.color.start_window_background'))
                        .margin({ top: CommonConstant.WebConstant_BUTTON_MARGIN_TOP })
                        .width(CommonConstant.WebConstant_BUTTON_WIDTH)
                        .height(CommonConstant.WebConstant_BUTTON_HEIGHT)
                        .backgroundColor($r('app.color.blue'))
                        .borderRadius(CommonConstant.WebConstant_BUTTON_BORDER_RADIUS)
                        .onClick(() => {
                            this.webController.runJavaScript('startDraw()')
                        })
                }
                .width(CommonConstant.WebConstant_FULL_WIDTH)
                .height(CommonConstant.WebConstant_FULL_HEIGHT)
            }

            if (this.isLoading) {
                Progress({
                    value: CommonConstant.WebConstant_PROGRESS_MIN,
                    total: CommonConstant.WebConstant_PROGRESS_MAX,
                    type: ProgressType.ScaleRing
                })
                    .color(Color.Grey)
                    .value(this.progressVal)
                    .width(CommonConstant.WebConstant_PROGRESS_WIDTH)
                    .style({
                        strokeWidth: CommonConstant.WebConstant_PROGRESS_STROKE_WIDTH,
                        scaleCount: CommonConstant.WebConstant_PROGRESS_SCALE_COUNT,
                        scaleWidth: CommonConstant.WebConstant_PROGRESS_SCALE_WIDTH
                    })
                    .zIndex(1)
                    .position({
                        x: CommonConstant.WebConstant_PROGRESS_POSITION_X,
                        y: CommonConstant.WebConstant_PROGRESS_POSITION_Y
                    })

            }
        }
    }
}