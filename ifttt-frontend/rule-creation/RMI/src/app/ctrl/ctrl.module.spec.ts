import { CtrlModule } from './ctrl.module';

describe('CtrlModule', () => {
  let ctrlModule: CtrlModule;

  beforeEach(() => {
    ctrlModule = new CtrlModule();
  });

  it('should create an instance', () => {
    expect(ctrlModule).toBeTruthy();
  });
});
